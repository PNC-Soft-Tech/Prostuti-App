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
import '../../../common/services/auth_service.dart';
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
  final RxBool isLoadingProfilePic = false.obs;

  // API
  final ApiHelper _api = Get.find<ApiHelper>();
  final AuthService _authService = Get.find<AuthService>();

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
    
    print("DEBUG: ProfileController.onInit - Initializing controller");
    
    _checkAuthAndLoadProfile();
  }

  /// Check authentication and load profile if authenticated
  void _checkAuthAndLoadProfile() async {
    final hasAccess = await _authService.checkFeatureAccess(
      featureName: 'profile',
      customMessage: 'Please login to view and manage your profile.',
    );
    
    if (hasAccess) {
      // First fetch institution types (needed for the dropdown)
      fetchInstitutionTypes().then((_) {
        // After institution types are loaded, load the user profile
        _loadCachedOrFetchProfile().then((_) {
          // Start the refresh timer after initial profile load
          startProfileRefreshTimer();
        });
      });
    }
  }

  Future<void> _loadCachedOrFetchProfile() async {
    print("DEBUG: _loadCachedOrFetchProfile - Starting profile loading process");
    isLoadingProfilePic.value = true;
    
    // 1) Try loading cached JSON
    print("DEBUG: _loadCachedOrFetchProfile - Attempting to load from cache");
    final cached = await StorageHelper.getUserData();
    
    if (cached != null) {
      print("DEBUG: _loadCachedOrFetchProfile - Cache found, length: ${cached.length} chars");
      try {
        final Map<String, dynamic> json = jsonDecode(cached);
        print("DEBUG: _loadCachedOrFetchProfile - Cache parsed as JSON");
        
        // Check if profilePic exists in the cached data
        if (json.containsKey('profilePic')) {
          print("DEBUG: _loadCachedOrFetchProfile - Cached profilePic: '${json['profilePic']}'");
        } else {
          print("DEBUG: _loadCachedOrFetchProfile - No profilePic in cached JSON");
        }
        
        final profil = UserProfile.fromJson(json);
        print("DEBUG: _loadCachedOrFetchProfile - Created UserProfile from cache");
        print("DEBUG: _loadCachedOrFetchProfile - profilePic after parsing: '${profil.profilePic}'");
        
        userProfile.value = profil;
        isLoadingProfilePic.value = false;
        
        // Ensure profile pic is valid
        if (profil.profilePic.isNotEmpty && profil.profilePic != 'null') {
          profileImageUrl.value = profil.profilePic;
          print("DEBUG: _loadCachedOrFetchProfile - Set profileImageUrl from cache: '${profileImageUrl.value}'");
        } else {
          // Use default image if needed
          profileImageUrl.value = 'https://picsum.photos/id/1/200/300';
          print("DEBUG: _loadCachedOrFetchProfile - Using default image URL");
        }
        
        _populateFields(profil);
        return;
      } catch (e) {
        print("ERROR: _loadCachedOrFetchProfile - Cache parsing failed: $e");
        isLoadingProfilePic.value = false;
        // parsing failed—fall through to API fetch
      }
    } else {
      print("DEBUG: _loadCachedOrFetchProfile - No cache found, will fetch from API");
    }

    // 2) No valid cache, fetch from API
    print("DEBUG: _loadCachedOrFetchProfile - Fetching from API");
    final storedUserId = await StorageHelper.getUserId();
    print("DEBUG: _loadCachedOrFetchProfile - Stored userId: $storedUserId");
    
    // Use a valid user ID - either from storage or hardcoded for testing
    String validUserId = storedUserId ?? '677ab9c32847a2fcc732028f';
    
    // Sanitize: if it looks like a full JSON object or contains invalid characters, use the hardcoded ID
    if (validUserId.contains('{') || validUserId.contains(':') || validUserId.contains(' ')) {
      print("DEBUG: _loadCachedOrFetchProfile - Invalid userId format, using hardcoded ID");
      validUserId = '677ab9c32847a2fcc732028f';
    }
    
    userId.value = validUserId;
    print("DEBUG: _loadCachedOrFetchProfile - Using userId: ${userId.value}");

    print("DEBUG: _loadCachedOrFetchProfile - Calling API getUserProfile");
    final result = await _api.getUserProfile(userId.value);
    result.fold(
      (err) {
        print("ERROR: _loadCachedOrFetchProfile - API error: ${err.message}");
        isLoadingProfilePic.value = false;
        Utils.showSnackbar(
          message: 'Failed to load profile: ${err.message}',
          isSuccess: false,
        );
      },
      (profil) {
        print("DEBUG: Profile loaded from API - User ID: ${profil.id}, FullName: ${profil.fullName}");
        print("DEBUG: Raw profile pic from API: '${profil.profilePic}'");
        
        userProfile.value = profil;
        
        // Ensure profile image URL is valid
        if (profil.profilePic.isNotEmpty && profil.profilePic != 'null') {
          profileImageUrl.value = profil.profilePic; // Set profile image URL
          print("DEBUG: Setting profile image URL to: ${profil.profilePic}");
        } else {
          // Set a default profile image if none is provided
          profileImageUrl.value = 'https://picsum.photos/id/1/200/300';
          print("DEBUG: Using default profile image URL: ${profileImageUrl.value}");
        }
        
        _populateFields(profil);
        
        // cache the fresh data
        print("DEBUG: _loadCachedOrFetchProfile - Saving profile to cache");
        StorageHelper.setUserData(profil.toJson());
        
        // Make sure the userId is stored properly
        if (profil.id != null) {
          StorageHelper.setUserId(profil.id!);
          print("DEBUG: _loadCachedOrFetchProfile - Saved userId: ${profil.id}");
        }
        isLoadingProfilePic.value = false;
        
        // Log final state
        print("DEBUG: Profile state after loading - profileImageUrl: '${profileImageUrl.value}'");
        print("DEBUG: Profile state after loading - userProfile.profilePic: '${userProfile.value?.profilePic}'");
      },
    );
  }

  // Nothing here - removed debug method

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
    print("DEBUG: saveProfile - Starting profile save process");
    
    if (userProfile.value == null) {
      print("ERROR: saveProfile - userProfile.value is null, cannot save");
      return;
    }
    
    // Display a loading indicator
    Utils.showSnackbar(message: 'Saving profile...', isSuccess: true);
    
    // Log current profile image state
    print("DEBUG: Before save - profileImageUrl.value: '${profileImageUrl.value}'");
    print("DEBUG: Before save - userProfile.profilePic: '${userProfile.value?.profilePic}'");
    
    // Ensure profileImageUrl is valid
    if (profileImageUrl.value.isNotEmpty && profileImageUrl.value != 'null') {
      if (isValidImageUrl(profileImageUrl.value)) {
        print("DEBUG: saveProfile - profileImageUrl validation passed");
        
        // Try to verify that the URL actually returns an image
        try {
          final isVerified = await verifyImageUrl(profileImageUrl.value);
          print("DEBUG: saveProfile - profileImageUrl verification result: $isVerified");
        } catch (e) {
          print("WARNING: saveProfile - Error verifying image URL: $e");
        }
      } else {
        print("WARNING: saveProfile - profileImageUrl failed validation: '${profileImageUrl.value}'");
        
        // Generate URL variants to try
        final variants = generateUrlVariants(profileImageUrl.value);
        
        // Find a valid variant
        for (final variant in variants.skip(1)) { // Skip the first one (original)
          if (isValidImageUrl(variant)) {
            print("DEBUG: saveProfile - Found valid URL variant: '$variant'");
            profileImageUrl.value = variant;
            break;
          }
        }
      }
    } else {
      print("DEBUG: saveProfile - profileImageUrl is empty or 'null'");
    }
    
    // Parse date of birth with proper error handling
    DateTime? dateOfBirth;
    if (dobController.text.isNotEmpty) {
      try {
        dateOfBirth = DateTime.parse(dobController.text);
      } catch (e) {
        print('Error parsing date: $e');
        Utils.showSnackbar(
          message: 'Invalid date format. Please use YYYY-MM-DD format.',
          isSuccess: false,
        );
        // Don't return, just continue with null date
      }
    }
    
    // Validate required fields
    if (fullNameController.text.isEmpty || emailController.text.isEmpty) {
      Utils.showSnackbar(
        message: 'Name and email are required.',
        isSuccess: false,
      );
      return;
    }
    
    // Process profile picture URL
    print("DEBUG: saveProfile - Starting profile image URL processing");
    
    String profilePicUrl = userProfile.value!.profilePic;
    print("DEBUG: saveProfile - Current userProfile.profilePic: '$profilePicUrl'");
    
    if (profileImageUrl.value.isNotEmpty && profileImageUrl.value != 'null') {
      print("DEBUG: saveProfile - Found non-empty profileImageUrl.value: '${profileImageUrl.value}'");
      
      // Validate the new URL before using it
      if (isValidImageUrl(profileImageUrl.value)) {
        profilePicUrl = profileImageUrl.value;
        print("DEBUG: saveProfile - Using valid uploaded profile pic: '$profilePicUrl'");
      } else {
        print("WARNING: saveProfile - Invalid uploaded profileImageUrl: '${profileImageUrl.value}'");
        // Keep the existing URL if the new one is invalid
      }
    } else {
      print("DEBUG: saveProfile - No uploaded image, checking existing profile pic: '$profilePicUrl'");
    }
    
    // Final validation to ensure we have a working URL
    if (!isValidImageUrl(profilePicUrl)) {
      profilePicUrl = 'https://picsum.photos/id/1/200/300';
      print("DEBUG: saveProfile - Using default profile pic URL: '$profilePicUrl'");
    }
    
    // Create updated profile
    var updated = userProfile.value!.copyWith(
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
      profilePic: profilePicUrl,
    );

    print("DEBUG: Updated profile object profilePic: '${updated.profilePic}'");

    try {
      final result = await _api.updateUserProfile(updated);
      result.fold(
        (err) {
          print("DEBUG: Error updating profile: ${err.message}");
          Utils.showSnackbar(message: 'Error: ${err.message}', isSuccess: false);
        },
        (fresh) {
          print("DEBUG: Profile updated successfully");
          print("DEBUG: Updated profile pic from response: '${fresh.profilePic}'");
          
          userProfile.value = fresh;
          profileImageUrl.value = fresh.profilePic;
          
          // Save updated profile to storage
          try {
            StorageHelper.setUserData(fresh.toJson());
            
            // Make sure the userId is stored properly
            if (fresh.id != null) {
              StorageHelper.setUserId(fresh.id!);
            }
          } catch (e) {
            print('Error saving profile to storage: $e');
          }
          
          Utils.showSnackbar(message: 'Profile saved!', isSuccess: true);
        },
      );
    } catch (e) {
      print('Error saving profile: $e');
      Utils.showSnackbar(
        message: 'Failed to save profile. Please try again.',
        isSuccess: false,
      );
    }
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
    if (selectedImage.value == null) {
      print("DEBUG: uploadImageToImgbb - No image selected");
      return;
    }
    
    print("DEBUG: uploadImageToImgbb - Starting upload process");
    print("DEBUG: uploadImageToImgbb - Image path: ${selectedImage.value!.path}");
    
    isUploadingImage.value = true;
    
    try {
      // Verify the file exists and is accessible
      if (!await selectedImage.value!.exists()) {
        print("ERROR: uploadImageToImgbb - Image file doesn't exist or isn't accessible");
        throw Exception("Image file doesn't exist or isn't accessible");
      }
      
      // Check file size (limit to 2MB)
      final fileSize = await selectedImage.value!.length();
      print("DEBUG: uploadImageToImgbb - Image size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB");
      
      if (fileSize > 2 * 1024 * 1024) {
        print("ERROR: uploadImageToImgbb - Image too large");
        Utils.showSnackbar(
          message: 'Image is too large (${(fileSize / 1024 / 1024).toStringAsFixed(1)}MB). Maximum size is 2MB.',
          isSuccess: false,
        );
        isUploadingImage.value = false;
        return;
      }
      
      // Create multipart request with timeout
      final uri = Uri.parse('https://api.imgbb.com/1/upload');
      print("DEBUG: uploadImageToImgbb - Using API endpoint: $uri");
      
      final request = http.MultipartRequest('POST', uri)
        ..fields['key'] = imgbbApiKey;
      
      // Add image file
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        selectedImage.value!.path,
      );
      
      request.files.add(multipartFile);
      print("DEBUG: uploadImageToImgbb - Request prepared with file attached");
      
      // Send request with timeout
      print("DEBUG: uploadImageToImgbb - Sending request...");
      final streamedResponse = await request.send()
          .timeout(const Duration(seconds: 30), onTimeout: () {
        print("ERROR: uploadImageToImgbb - Request timed out");
        throw TimeoutException('Request timed out after 30 seconds');
      });
      
      print("DEBUG: uploadImageToImgbb - Response status code: ${streamedResponse.statusCode}");
      
      final response = await http.Response.fromStream(streamedResponse);
      print("DEBUG: uploadImageToImgbb - Response body length: ${response.body.length} chars");
      
      // Check if response is valid JSON
      Map<String, dynamic>? jsonData;
      try {
        jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        print("DEBUG: uploadImageToImgbb - Response parsed successfully as JSON");
      } catch (e) {
        print("ERROR: uploadImageToImgbb - Invalid response format: ${response.body}");
        throw FormatException('Invalid response format: ${response.body}');
      }
      
      // Check response
      if (response.statusCode == 200 && jsonData['success'] == true) {
        // Get image URL from response
        final responseData = jsonData['data'];
        print("DEBUG: ImgBB upload successful response: $responseData");
        
        final imageUrl = responseData['url'] as String;
        print("DEBUG: ImgBB uploaded image URL: '$imageUrl'");
        
        // Also log the direct display URL and delete URL for debugging
        if (responseData['display_url'] != null) {
          print("DEBUG: ImgBB display URL: '${responseData['display_url']}'");
        }
        if (responseData['thumb'] != null) {
          print("DEBUG: ImgBB thumbnail: '${responseData['thumb']}'");
        }
        
        // CHANGE: Try using display_url instead if available
        final finalUrl = responseData['display_url'] as String? ?? imageUrl;
        
        // Update the profile image URL
        profileImageUrl.value = finalUrl;
        print("DEBUG: Updated profileImageUrl.value to: '${profileImageUrl.value}'");
        
        // Important: Also update the userProfile object's profilePic field
        if (userProfile.value != null) {
          final updatedProfile = userProfile.value!.copyWith(profilePic: finalUrl);
          userProfile.value = updatedProfile;
          print("DEBUG: Also updated userProfile.value.profilePic: '${userProfile.value!.profilePic}'");
        }
        
        Utils.showSnackbar(
          message: 'Image uploaded successfully!',
          isSuccess: true,
        );
      } else {
        final errorMessage = jsonData['error']?['message'] as String? ?? 'Unknown error';
        print("ERROR: ImgBB upload error: $errorMessage");
        print("ERROR: Full error response: ${jsonData['error']}");
        
        Utils.showSnackbar(
          message: 'Failed to upload image: $errorMessage',
          isSuccess: false,
        );
      }
    } catch (e) {
      print('ERROR: Error uploading image: $e');
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

  // Try to fix common URL issues 
  List<String> generateUrlVariants(String originalUrl) {
    final List<String> variants = [];
    
    // Add the original URL
    variants.add(originalUrl);
    
    try {
      // Parse the original URL
      final uri = Uri.parse(originalUrl);
      
      // URL might be encoded incorrectly, try different formats
      if (originalUrl.contains('%')) {
        // Try decoding if it has percent encoding
        try {
          final decoded = Uri.decodeFull(originalUrl);
          if (decoded != originalUrl) {
            variants.add(decoded);
          }
        } catch (e) {
          print("DEBUG: Error decoding URL: $e");
        }
      } else {
        // Try encoding if it doesn't have percent encoding
        try {
          final encoded = Uri.encodeFull(originalUrl);
          if (encoded != originalUrl) {
            variants.add(encoded);
          }
        } catch (e) {
          print("DEBUG: Error encoding URL: $e");
        }
      }
      
      // Add variants with different schemes
      if (uri.scheme == 'http') {
        variants.add(originalUrl.replaceFirst('http://', 'https://'));
      } else if (uri.scheme == 'https') {
        variants.add(originalUrl.replaceFirst('https://', 'http://'));
      }
      
      // Extract domain and path to create a simpler URL
      final baseUrl = '${uri.scheme}://${uri.host}${uri.path}';
      if (baseUrl != originalUrl) {
        variants.add(baseUrl);
      }
      
      // Log all variants for debugging
      print("DEBUG: Generated URL variants:");
      for (int i = 0; i < variants.length; i++) {
        print("DEBUG:   [$i] ${variants[i]}");
      }
    } catch (e) {
      print("DEBUG: Error generating URL variants: $e");
    }
    
    return variants;
  }

  // Verify that an image URL actually returns an image
  Future<bool> verifyImageUrl(String url) async {
    print("DEBUG: verifyImageUrl - Checking image URL: '$url'");
    
    if (!isValidImageUrl(url)) {
      print("DEBUG: verifyImageUrl - URL did not pass basic validation");
      return false;
    }
    
    try {
      print("DEBUG: verifyImageUrl - Sending HEAD request to: '$url'");
      
      // Try a HEAD request first to check if the URL exists
      final response = await http.head(Uri.parse(url)).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print("DEBUG: verifyImageUrl - HEAD request timed out");
          return http.Response('Timeout', 408);
        }
      );
      
      print("DEBUG: verifyImageUrl - HEAD response status: ${response.statusCode}");
      
      // Check if content type is an image
      final contentType = response.headers['content-type'] ?? '';
      print("DEBUG: verifyImageUrl - Content-Type: $contentType");
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (contentType.startsWith('image/')) {
          print("DEBUG: verifyImageUrl - URL is verified as valid image");
          return true;
        } else {
          print("DEBUG: verifyImageUrl - URL exists but is not an image");
          return false;
        }
      } else {
        print("DEBUG: verifyImageUrl - URL returned error status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("ERROR: verifyImageUrl - Exception: $e");
      return false;
    }
  }
  
  // Enhanced version of getValidProfileImageUrl that checks server response
  Future<String> verifyAndGetValidProfileImageUrl() async {
    String? url = userProfile.value?.profilePic;
    print("DEBUG: verifyAndGetValidProfileImageUrl - Starting with: '$url'");
    
    // Check if the URL from userProfile is valid
    if (url != null && url.isNotEmpty && url != 'null') {
      if (await verifyImageUrl(url)) {
        print("DEBUG: verifyAndGetValidProfileImageUrl - Using verified profile image URL from userProfile: '$url'");
        return url;
      }
    }
    
    // Try the profileImageUrl value next
    url = profileImageUrl.value;
    if (url.isNotEmpty && url != 'null') {
      if (await verifyImageUrl(url)) {
        print("DEBUG: verifyAndGetValidProfileImageUrl - Using verified profile image URL from profileImageUrl: '$url'");
        return url;
      }
    }
    
    // Fall back to default
    const defaultUrl = 'https://picsum.photos/id/1/200/300';
    print("DEBUG: verifyAndGetValidProfileImageUrl - Using default profile image URL: '$defaultUrl'");
    return defaultUrl;
  }

  // Helper method to validate an image URL
  bool isValidImageUrl(String? url) {
    print("DEBUG: Validating image URL: '$url'");
    
    if (url == null || url.isEmpty || url == 'null') {
      print("DEBUG: URL validation failed - URL is null or empty");
      return false;
    }
    
    try {
      final uri = Uri.parse(url.trim());
      if (!uri.isAbsolute) {
        print("DEBUG: URL validation failed - URL is not absolute: '$url'");
        return false;
      }
      
      if (!uri.scheme.startsWith('http') && !uri.scheme.startsWith('https')) {
        print("DEBUG: URL validation failed - Invalid scheme: '${uri.scheme}'");
        return false;
      }
      
      // URL looks valid
      print("DEBUG: URL validation passed: '$url'");
      return true;
    } catch (e) {
      print("DEBUG: URL validation failed - Parse error: $e");
      return false;
    }
  }
  
  // This was removed because there's already an isValidImageUrl function defined above

  // Get a valid profile image URL or default if none available
  String getValidProfileImageUrl() {
    // First try the URL from userProfile
    String? url = userProfile.value?.profilePic;
    print("DEBUG: getValidProfileImageUrl - userProfile.profilePic: '$url'");
    
    if (isValidImageUrl(url)) {
      print("DEBUG: getValidProfileImageUrl - Using profile pic from userProfile: '$url'");
      return url!;
    }
    
    // Next, try the profileImageUrl 
    url = profileImageUrl.value;
    print("DEBUG: getValidProfileImageUrl - profileImageUrl.value: '$url'");
    
    if (isValidImageUrl(url)) {
      print("DEBUG: getValidProfileImageUrl - Using profile pic from profileImageUrl: '$url'");
      return url;
    }
    
    // Use default if all else fails
    const defaultUrl = 'https://picsum.photos/id/1/200/300';
    print("DEBUG: getValidProfileImageUrl - Using default profile image URL: '$defaultUrl'");
    return defaultUrl;
  }
  
  // Refresh profile data periodically to ensure we have the latest information
  void startProfileRefreshTimer() {
    print("DEBUG: Starting periodic profile refresh timer");
    
    // Cancel existing timer if one exists
    _refreshTimer?.cancel();
    
    // Refresh every 30 seconds while the profile view is active
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Only refresh if we're still on the profile page
      if (currentIndex.value == 3) { // Assuming 3 is the profile tab index
        print("DEBUG: Periodic profile refresh timer triggered");
        
        // Refresh profile data but avoid showing loading spinner again
        _refreshProfileDataSilently();
      }
    });
  }
  
  // Refresh profile data without showing loading indicators
  Future<void> _refreshProfileDataSilently() async {
    print("DEBUG: _refreshProfileDataSilently - Starting quiet refresh");
    
    if (userId.value.isEmpty) {
      print("DEBUG: _refreshProfileDataSilently - No userId available");
      return;
    }
    
    final result = await _api.getUserProfile(userId.value);
    result.fold(
      (err) {
        print("ERROR: _refreshProfileDataSilently - Failed to refresh profile: ${err.message}");
      },
      (profil) {
        print("DEBUG: _refreshProfileDataSilently - Profile refreshed successfully");
        
        // Only update if there's a real change to avoid unnecessary rebuilds
        if (userProfile.value?.profilePic != profil.profilePic) {
          print("DEBUG: _refreshProfileDataSilently - Profile image URL updated from '${userProfile.value?.profilePic}' to '${profil.profilePic}'");
          
          // Update the profile data
          userProfile.value = profil;
          
          // Update the profile image URL if it's valid
          if (isValidImageUrl(profil.profilePic)) {
            profileImageUrl.value = profil.profilePic;
            
            // Try to precache the new image in the background if context is available
            if (Get.context != null) {
              precacheProfileImage(Get.context);
            }
          }
          
          // Update the cached data
          StorageHelper.setUserData(profil.toJson());
        } else {
          print("DEBUG: _refreshProfileDataSilently - No changes to profile image URL");
        }
      },
    );
  }
  
  // Timer for periodic profile refresh
  Timer? _refreshTimer;
  
  @override
  void onClose() {
    print("DEBUG: ProfileController.onClose - Disposing controller");
    
    // Cancel timer if it's active
    _refreshTimer?.cancel();
    
    // Dispose all text controllers
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

  // Precache the profile image to ensure it loads faster when needed
  Future<bool> precacheProfileImage(BuildContext? context) async {
    if (context == null) return false;
    
    final imageUrl = getValidProfileImageUrl();
    print("DEBUG: precacheProfileImage - Attempting to precache: '$imageUrl'");
    
    if (!isValidImageUrl(imageUrl)) {
      print("DEBUG: precacheProfileImage - URL is invalid, not precaching");
      return false;
    }
    
    try {
      // Create a network image provider
      final imageProvider = NetworkImage(imageUrl);
      
      // Start precaching (no need to capture the result)
      await precacheImage(imageProvider, context);
      print("DEBUG: precacheProfileImage - Precaching completed for: '$imageUrl'");
      return true;
    } catch (e) {
      print("ERROR: precacheProfileImage - Failed to precache image: $e");
      return false;
    }
  }
}
