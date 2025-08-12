import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/controller/app_controller.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../models/package_model.dart';
import '../services/bkash_payment_service.dart';

class PackageDetailsController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AppController appController = Utils.getAppController();

  // Observables
  var isLoading = false.obs;
  var isPaymentProcessing = false.obs;
  var availablePackages = <PackageModel>[].obs;
  var currentSubscription = Rxn<SubscriptionModel>();
  var selectedPackage = Rxn<PackageModel>();

  // Payment form controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadAvailablePackages();
    checkCurrentSubscription();
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  /// Load available packages from API
  Future<void> loadAvailablePackages() async {
    try {
      isLoading.value = true;
      final result = await _apiHelper.getAvailablePackages();
      
      result.fold(
        (error) {
          Utils.showSnackbar(
            message: error.message,
            isSuccess: false,
          );
        },
        (packagesData) {
          availablePackages.value = packagesData
              .map((data) => PackageModel.fromJson(data))
              .toList();
        },
      );
    } catch (e) {
      Utils.showSnackbar(
        message: 'Failed to load packages: $e',
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Check current user subscription status
  Future<void> checkCurrentSubscription() async {
    try {
      final userId = appController.userId.value;
      if (userId.isEmpty) return;

      final result = await _apiHelper.getSubscriptionStatus(userId);
      
      result.fold(
        (error) {
          // User might not have any subscription, that's okay
          print('No active subscription found: ${error.message}');
        },
        (subscriptionData) {
          currentSubscription.value = SubscriptionModel.fromJson(subscriptionData);
        },
      );
    } catch (e) {
      print('Error checking subscription: $e');
    }
  }

  /// Check if a package is currently active for the user
  bool isPackageActive(String packageId) {
    final subscription = currentSubscription.value;
    return subscription != null && 
           subscription.isActive && 
           subscription.package.id == packageId;
  }

  /// Initiate bKash payment for selected package
  Future<void> initiateBkashPayment(PackageModel package) async {
    if (phoneController.text.trim().isEmpty) {
      Utils.showSnackbar(
        message: 'Please enter your bKash phone number',
        isSuccess: false,
      );
      return;
    }

    if (!_isValidBangladeshiPhone(phoneController.text.trim())) {
      Utils.showSnackbar(
        message: 'Please enter a valid Bangladeshi phone number',
        isSuccess: false,
      );
      return;
    }

    try {
      isPaymentProcessing.value = true;
      selectedPackage.value = package;

      final customerPhone = phoneController.text.trim();
      
      // Use bKash payment service
      final response = await BkashPaymentService.makePayment(
        package: package,
        customerPhone: customerPhone,
        intent: 'sale',
      );

      if (BkashPaymentService.isPaymentSuccessful(response)) {
        // Payment was successful
        await _handleSuccessfulPayment(package, response!);
      } else {
        Utils.showSnackbar(
          message: 'Payment was cancelled or failed',
          isSuccess: false,
        );
      }
    } catch (e) {
      Utils.showSnackbar(
        message: 'Payment initiation failed: $e',
        isSuccess: false,
      );
    } finally {
      isPaymentProcessing.value = false;
    }
  }

  /// Handle successful payment
  Future<void> _handleSuccessfulPayment(PackageModel package, BkashResponse response) async {
    try {
      // Verify payment with bKash
      final isVerified = await BkashPaymentService.verifyPayment(
        paymentId: response.paymentId!,
        package: package,
      );

      if (isVerified) {
        // Activate subscription
        await _activateSubscriptionWithPayment(package, response);
      } else {
        Utils.showSnackbar(
          message: 'Payment verification failed. Please contact support.',
          isSuccess: false,
        );
      }
    } catch (e) {
      Utils.showSnackbar(
        message: 'Payment verification error: $e',
        isSuccess: false,
      );
    }
  }

  /// Activate subscription with payment details
  Future<void> _activateSubscriptionWithPayment(PackageModel package, BkashResponse paymentResponse) async {
    try {
      final subscriptionData = {
        'userId': appController.userId.value,
        'packageId': package.id,
        'paymentData': {
          'paymentId': paymentResponse.paymentId,
          'trxId': paymentResponse.trxId,
          'amount': paymentResponse.amount,
          'transactionStatus': paymentResponse.transactionStatus,
          'paymentCreateTime': paymentResponse.paymentCreateTime,
          'customerMsisdn': paymentResponse.customerMsisdn,
          'merchantInvoiceNumber': paymentResponse.merchantInvoiceNumber,
        },
      };

      final result = await _apiHelper.activateSubscription(subscriptionData);
      
      result.fold(
        (error) {
          Utils.showSnackbar(
            message: 'Failed to activate subscription: ${error.message}',
            isSuccess: false,
          );
        },
        (subscriptionResponse) {
          Utils.showSnackbar(
            message: 'Subscription activated successfully!',
            isSuccess: true,
          );
          
          // Refresh subscription status
          checkCurrentSubscription();
          
          // Show success dialog
          _showPaymentSuccessDialog(package, paymentResponse);
        },
      );
    } catch (e) {
      Utils.showSnackbar(
        message: 'Error activating subscription: $e',
        isSuccess: false,
      );
    }
  }

  /// Show payment success dialog
  void _showPaymentSuccessDialog(PackageModel package, BkashResponse paymentResponse) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 50,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your ${package.displayName} subscription has been activated.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Transaction ID:'),
                        Text(
                          paymentResponse.trxId ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount:'),
                        Text(
                          package.formattedPrice,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back(); // Return to previous screen
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Validate Bangladeshi phone number
  bool _isValidBangladeshiPhone(String phone) {
    // Remove any spaces or dashes
    phone = phone.replaceAll(RegExp(r'[\s-]'), '');
    
    // Check if it's a valid Bangladeshi mobile number
    final regex = RegExp(r'^(?:\+88|88)?01[3-9]\d{8}$');
    return regex.hasMatch(phone);
  }

  /// Clear phone number input
  void clearPhone() {
    phoneController.clear();
  }

  /// Format phone number for display
  String formatPhoneNumber(String phone) {
    if (phone.length >= 11) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6)}';
    }
    return phone;
  }
}
