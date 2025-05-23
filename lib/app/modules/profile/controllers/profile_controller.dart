// lib/modules/profile/profile_controller.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../storage/storage_helper.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../models/user_model.dart';
import '../../../models/institution.dart';
import '../../../models/institution_type.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  // -- existing state --
  var title = 'Profile Page'.obs;
  final userId = ''.obs;
  RxInt currentIndex = 0.obs;

  void updateTitle(String newTitle) => title.value = newTitle;

  // Navigate to a specific tab in the home view
  void navigateToIndex(int index) {
    Get.offNamed(Routes.home, arguments: {'tabIndex': index});
  }

  // -- form controllers --
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final divisionController = TextEditingController();
  final districtController = TextEditingController();
  final upazillaController = TextEditingController();
  final postCodeController = TextEditingController();
  final presentAddressController = TextEditingController();
  final permanentAddressController = TextEditingController();
  final institutionTypeController = TextEditingController();
  final cgpaController = TextEditingController();
  final institutionNameController = TextEditingController();

  // Dropdown values
  var selectedGender = Rxn<String>();
  var selectedDivision = Rxn<String>();
  var selectedDistrict = Rxn<String>();
  var selectedUpazilla = Rxn<String>();
  
  // Institution data
  var institutionTypes = <InstitutionType>[].obs;
  var institutions = <Institution>[].obs;
  var selectedInstitutionType = Rxn<InstitutionType>();
  var selectedInstitution = Rxn<Institution>();
  var isLoadingInstitutions = false.obs;

  // reactive holder for profile
  final Rxn<UserProfile> userProfile = Rxn<UserProfile>();

  // API
  final ApiHelper _api = Get.find<ApiHelper>();

  // Profile image variables
  final Rxn<File> selectedImage = Rxn<File>();
  final RxBool isUploadingImage = false.obs;
  final RxString profileImageUrl = ''.obs;
  final ImagePicker _imagePicker = ImagePicker();
  
  // ImgBB API key
  final String imgbbApiKey = '7b2df886bbb1704f6ffd66486cd13fdb';

  @override
  void onInit() {
    super.onInit();
    
    // First fetch institution types (needed for the dropdown)
    fetchInstitutionTypes().then((_) {
      // After institution types are loaded, load the user profile
      _loadCachedOrFetchProfile();
    });
  }

  Future<void> _loadCachedOrFetchProfile() async {
    // 1) Try loading cached JSON
    final cached = await StorageHelper.getUserData();
    if (cached != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(cached);
        final profil = UserProfile.fromJson(json);
        userProfile.value = profil;
        profileImageUrl.value = profil.profilePic; // Set profile image URL
        _populateFields(profil);
        return;
      } catch (e) {
        // parsing failed—fall through to API fetch
        print('Error decoding cached profile: $e');
      }
    }

    // 2) No valid cache, fetch from API
    final storedUserId = await StorageHelper.getUserId();
    print('Stored userId from SharedPreferences: $storedUserId');
    
    // Use a valid user ID - either from storage or hardcoded for testing
    String validUserId = storedUserId ?? '677ab9c32847a2fcc732028f';
    
    // Sanitize: if it looks like a full JSON object or contains invalid characters, use the hardcoded ID
    if (validUserId.contains('{') || validUserId.contains(':') || validUserId.contains(' ')) {
      print('UserId appears to be corrupted, using fallback');
      validUserId = '677ab9c32847a2fcc732028f';
    }
    
    userId.value = validUserId;
    print('Final userId being used for API call: ${userId.value}');

    final result = await _api.getUserProfile(userId.value);
    result.fold(
      (err) {
        Utils.showSnackbar(
          message: 'Failed to load profile: ${err.message}',
          isSuccess: false,
        );
      },
      (profil) {
        userProfile.value = profil;
        profileImageUrl.value = profil.profilePic; // Set profile image URL
        _populateFields(profil);
        // cache the fresh data
        StorageHelper.setUserData(profil.toJson());
        
        // Make sure the userId is stored properly
        if (profil.id != null) {
          StorageHelper.setUserId(profil.id!);
        }
      },
    );
  }

  void _populateFields(UserProfile p) {
    fullNameController.text = p.fullName;
    emailController.text = p.email;
    phoneController.text = p.phone ?? '';
    
    if (p.dateOfBirth != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(p.dateOfBirth!);
    }
    
    selectedGender.value = p.gender;
    selectedDivision.value = p.division;
    selectedDistrict.value = p.district;
    selectedUpazilla.value = p.upzilla;
    
    postCodeController.text = p.postCode ?? '';
    presentAddressController.text = p.presentAddress ?? '';
    permanentAddressController.text = p.permanentAddress ?? '';
    
    // Handle institution data
    if (p.institutionTypeObj != null) {
      selectedInstitutionType.value = p.institutionTypeObj;
      // We'll fetch institutions first, then set the selected institution
      fetchInstitutionsByType(p.institutionTypeObj!.id).then((_) {
        // Now that institutions are loaded, set selected institution if available
        if (p.institutionObj != null) {
          try {
            // Find matching institution in the loaded list
            final matchingInstitution = institutions.firstWhere(
              (inst) => inst.id == p.institutionObj!.id,
            );
            selectedInstitution.value = matchingInstitution;
          } catch (e) {
            // If not found in the list, use the original object
            selectedInstitution.value = p.institutionObj;
          }
        }
      });
    } else if (p.institutionType != null) {
      // If only the ID is available but not the full object, try to find it in the fetched types
      try {
        final matchingType = institutionTypes.firstWhere(
          (type) => type.id == p.institutionType,
        );
        selectedInstitutionType.value = matchingType;
        fetchInstitutionsByType(matchingType.id).then((_) {
          if (p.institution != null) {
            try {
              // Try to find the institution after loading
              final matchingInst = institutions.firstWhere(
                (inst) => inst.id == p.institution,
              );
              selectedInstitution.value = matchingInst;
            } catch (e) {
              // If not found in the list but we have the ID, create a temporary object
              selectedInstitution.value = Institution(
                id: p.institution!, 
                name: 'Unknown Institution', 
                slug: 'unknown'
              );
            }
          }
        });
      } catch (e) {
        // If institution type not found in list, create a temporary object
        selectedInstitutionType.value = InstitutionType(
          id: p.institutionType!, 
          name: 'Unknown Type', 
          slug: 'unknown'
        );
      }
    }
    
    // Set profile image URL
    profileImageUrl.value = p.profilePic;
    
    cgpaController.text = p.honsGpa.toString();
  }

  Future<void> fetchInstitutionTypes() async {
    final result = await _api.getInstitutionTypes();
    result.fold(
      (err) {
        Utils.showSnackbar(
          message: 'Failed to load institution types: ${err.message}',
          isSuccess: false,
        );
      },
      (types) {
        institutionTypes.value = types;
      },
    );
  }

  Future<void> fetchInstitutionsByType(String typeId) async {
    isLoadingInstitutions.value = true;
    institutions.clear(); // Clear existing institutions
    
    final result = await _api.getInstitutions(institutionTypeId: typeId);
    
    // Always set loading to false, regardless of result
    isLoadingInstitutions.value = false;
    
    result.fold(
      (err) {
        Utils.showSnackbar(
          message: 'Failed to load institutions: ${err.message}',
          isSuccess: false,
        );
        // Set empty list on error
        institutions.value = [];
      },
      (data) {
        institutions.value = data;
        
        // If we have a user profile with an institution and it matches one in this list,
        // select it automatically
        if (userProfile.value?.institution != null) {
          final institutionId = userProfile.value!.institution!;
          try {
            final matchingInstitution = institutions.firstWhere(
              (inst) => inst.id == institutionId,
            );
            selectedInstitution.value = matchingInstitution;
          } catch (e) {
            // No matching institution found, do nothing
          }
        }
      },
    );
  }

  void onInstitutionTypeChanged(InstitutionType? type) {
    if (type == null) return;
    
    // Set the selected institution type
    selectedInstitutionType.value = type;
    
    // Clear the currently selected institution since the type has changed
    selectedInstitution.value = null;
    
    // Clear the list of institutions and set loading state
    institutions.clear();
    isLoadingInstitutions.value = true;
    
    // Fetch institutions for the selected type
    fetchInstitutionsByType(type.id);
  }

  void onInstitutionChanged(Institution? institution) {
    if (institution == null) return;
    selectedInstitution.value = institution;
  }

  Future<void> saveProfile() async {
    if (userProfile.value == null) return;
    
    DateTime? dateOfBirth;
    if (dobController.text.isNotEmpty) {
      try {
        dateOfBirth = DateTime.parse(dobController.text);
      } catch (_) {}
    }
    
    final updated = userProfile.value!.copyWith(
      fullName: fullNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      dateOfBirth: dateOfBirth,
      gender: selectedGender.value,
      division: selectedDivision.value,
      district: selectedDistrict.value,
      upzilla: selectedUpazilla.value,
      postCode: postCodeController.text,
      presentAddress: presentAddressController.text,
      permanentAddress: permanentAddressController.text,
      institution: selectedInstitution.value?.id,
      institutionObj: selectedInstitution.value,
      institutionType: selectedInstitutionType.value?.id,
      institutionTypeObj: selectedInstitutionType.value,
      honsGpa: double.tryParse(cgpaController.text) ?? 0.0,
      profilePic: profileImageUrl.value.isNotEmpty ? profileImageUrl.value : userProfile.value!.profilePic,
    );

    final result = await _api.updateUserProfile(updated);
    result.fold(
      (err) => Utils.showSnackbar(message: err.message, isSuccess: false),
      (fresh) {
        userProfile.value = fresh;
        StorageHelper.setUserData(fresh.toJson());
        
        // Make sure the userId is stored properly
        if (fresh.id != null) {
          StorageHelper.setUserId(fresh.id!);
        }
        
        Utils.showSnackbar(message: 'Profile saved!', isSuccess: true);
      },
    );
  }

  // Pick image from camera or gallery
  Future<void> pickImage(ImageSource source) async {
    try {
      // Try to pick the image with error handling
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70, // Reduce image size while maintaining quality
        maxWidth: 800,    // Limit image dimensions to reduce size
        maxHeight: 800,
      );
      
      if (pickedFile != null) {
        try {
          // Create a file from the XFile
          selectedImage.value = File(pickedFile.path);
          // Start uploading as soon as image is picked
          await uploadImageToImgbb();
        } catch (fileError) {
          Utils.showSnackbar(
            message: 'Error processing selected image: $fileError',
            isSuccess: false,
          );
          print("File error: $fileError");
        }
      }
    } catch (e) {
      Utils.showSnackbar(
        message: 'Error selecting image: $e',
        isSuccess: false,
      );
      print("Image picker error: $e");
      
      // Show a more helpful message based on the error
      if (e.toString().contains("PlatformException")) {
        Utils.showSnackbar(
          message: 'Permission denied or image selection cancelled',
          isSuccess: false,
        );
      }
    }
  }
  
  // Show image source selection dialog
  void showImagePickerOptions() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  // Upload image to ImgBB and get URL
  Future<void> uploadImageToImgbb() async {
    if (selectedImage.value == null) return;
    
    isUploadingImage.value = true;
    
    try {
      // Verify the file exists and is accessible
      if (!await selectedImage.value!.exists()) {
        throw Exception("Image file doesn't exist or isn't accessible");
      }
      
      // Check file size (limit to 2MB)
      final fileSize = await selectedImage.value!.length();
      if (fileSize > 2 * 1024 * 1024) {
        Utils.showSnackbar(
          message: 'Image is too large (${(fileSize / 1024 / 1024).toStringAsFixed(1)}MB). Maximum size is 2MB.',
          isSuccess: false,
        );
        isUploadingImage.value = false;
        return;
      }
      
      // Create multipart request with timeout
      final uri = Uri.parse('https://api.imgbb.com/1/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['key'] = imgbbApiKey;
      
      // Add image file
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        selectedImage.value!.path,
      );
      
      request.files.add(multipartFile);
      
      // Send request with timeout
      final streamedResponse = await request.send()
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException('Request timed out after 30 seconds');
      });
      
      final response = await http.Response.fromStream(streamedResponse);
      
      // Check if response is valid JSON
      Map<String, dynamic>? jsonData;
      try {
        jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw FormatException('Invalid response format: ${response.body}');
      }
      
      // Check response
      if (response.statusCode == 200 && jsonData?['success'] == true) {
        // Get image URL from response
        final imageUrl = jsonData!['data']['url'] as String;
        profileImageUrl.value = imageUrl;
        
        Utils.showSnackbar(
          message: 'Image uploaded successfully!',
          isSuccess: true,
        );
      } else {
        final errorMessage = jsonData?['error']?['message'] as String? ?? 'Unknown error';
        Utils.showSnackbar(
          message: 'Failed to upload image: $errorMessage',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      String errorMessage = 'Error uploading image';
      
      if (e.toString().contains('SocketException')) {
        errorMessage = 'Network error: Please check your internet connection';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Upload timed out: Please try again';
      }
      
      Utils.showSnackbar(
        message: errorMessage,
        isSuccess: false,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    genderController.dispose();
    divisionController.dispose();
    districtController.dispose();
    upazillaController.dispose();
    postCodeController.dispose();
    presentAddressController.dispose();
    permanentAddressController.dispose();
    institutionTypeController.dispose();
    cgpaController.dispose();
    institutionNameController.dispose();
    super.onClose();
  }
}
