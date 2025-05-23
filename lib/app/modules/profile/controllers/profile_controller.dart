// lib/modules/profile/profile_controller.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
