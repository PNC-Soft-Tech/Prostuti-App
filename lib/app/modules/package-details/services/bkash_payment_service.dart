import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/package_model.dart';

/// bKash Response Model
class BkashResponse {
  final String? paymentId;
  final String? trxId;
  final String? amount;
  final String? transactionStatus;
  final String? paymentCreateTime;
  final String? customerMsisdn;
  final String? merchantInvoiceNumber;

  BkashResponse({
    this.paymentId,
    this.trxId,
    this.amount,
    this.transactionStatus,
    this.paymentCreateTime,
    this.customerMsisdn,
    this.merchantInvoiceNumber,
  });

  factory BkashResponse.fromJson(Map<String, dynamic> json) {
    return BkashResponse(
      paymentId: json['paymentID'],
      trxId: json['trxID'],
      amount: json['amount'],
      transactionStatus: json['transactionStatus'],
      paymentCreateTime: json['paymentCreateTime'],
      customerMsisdn: json['customerMsisdn'],
      merchantInvoiceNumber: json['merchantInvoiceNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentID': paymentId,
      'trxID': trxId,
      'amount': amount,
      'transactionStatus': transactionStatus,
      'paymentCreateTime': paymentCreateTime,
      'customerMsisdn': customerMsisdn,
      'merchantInvoiceNumber': merchantInvoiceNumber,
    };
  }
}

/// Mock bKash Payment Service
class BkashPaymentService {
  // bKash configuration (replace with real credentials)
  static const String _appKey = "4f6o0cjiki2rfm34kfdadl1eqq";
  static const String _appSecret = "2is7hdktrekvrbljjh44ll3d9l1dtjo4pasmjvs5vl5qr3fug4b";
  static const String _username = "sandboxTokenizedUser02";
  static const String _password = "sandboxTokenizedUser02@12345";
  static const bool _isSandbox = true;

  /// Make payment with bKash
  static Future<BkashResponse?> makePayment({
    required PackageModel package,
    required String customerPhone,
    required String intent,
  }) async {
    try {
      // Show payment dialog simulation
      final result = await Get.dialog<BkashResponse>(
        Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // bKash Logo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2136E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'bKash',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Simulation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Package: ${package.displayName}'),
                Text('Amount: ${package.formattedPrice}'),
                Text('Phone: $customerPhone'),
                const SizedBox(height: 20),
                const Text(
                  'This is a mock payment simulation. In production, this would open the real bKash payment gateway.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(result: null),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Simulate successful payment
                          final response = BkashResponse(
                            paymentId: 'PY${DateTime.now().millisecondsSinceEpoch}',
                            trxId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                            amount: package.price.toString(),
                            transactionStatus: 'Completed',
                            paymentCreateTime: DateTime.now().toIso8601String(),
                            customerMsisdn: customerPhone,
                            merchantInvoiceNumber: 'INV${DateTime.now().millisecondsSinceEpoch}',
                          );
                          Get.back(result: response);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE2136E),
                        ),
                        child: const Text(
                          'Pay Now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      return result;
    } catch (e) {
      print('Error in makePayment: $e');
      return null;
    }
  }

  /// Verify payment
  static Future<bool> verifyPayment({
    required String paymentId,
    required PackageModel package,
  }) async {
    try {
      // Simulate verification delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In mock mode, always return true
      // In real implementation, this would call bKash verify API
      return true;
    } catch (e) {
      print('Error in verifyPayment: $e');
      return false;
    }
  }

  /// Check if payment is successful
  static bool isPaymentSuccessful(BkashResponse? response) {
    return response != null && 
           response.transactionStatus == 'Completed' &&
           response.paymentId != null &&
           response.trxId != null;
  }

  /// Get payment status
  static Future<String> getPaymentStatus(String paymentId) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In mock mode, always return completed
      return 'Completed';
    } catch (e) {
      print('Error in getPaymentStatus: $e');
      return 'Failed';
    }
  }
}