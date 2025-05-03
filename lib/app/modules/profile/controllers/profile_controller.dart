// lib/modules/profile/profile_controller.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../storage/storage_helper.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../models/user_model.dart'; // assumes UserProfile is here

class ProfileController extends GetxController {
  // -- existing state --
  var title = 'Profile Page'.obs;
  final userId = ''.obs;
  RxInt currentIndex = 0.obs;

  void updateTitle(String newTitle) => title.value = newTitle;

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

  // reactive holder for profile
  final Rxn<UserProfile> userProfile = Rxn<UserProfile>();

  // API
  final ApiHelper _api = Get.find<ApiHelper>();

  @override
  void onInit() {
    super.onInit();
    _loadCachedOrFetchProfile();
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
      } catch (_) {
        // parsing failed—fall through to API fetch
      }
    }

    // 2) No valid cache, fetch from API
    userId.value = await StorageHelper.getUserId() ?? '';
    if (userId.value.isEmpty) return;

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
      },
    );
  }

  void _populateFields(UserProfile p) {
    fullNameController.text = p.fullName;
    emailController.text = p.email;
    phoneController.text = p.phone ?? '';
    dobController.text = p.dateOfBirth != null
        ? DateFormat('yyyy-MM-dd').format(p.dateOfBirth!)
        : '';
    genderController.text = p.gender ?? '';
    divisionController.text = p.division ?? '';
    districtController.text = p.district ?? '';
    upazillaController.text = p.upzilla ?? '';
    postCodeController.text = p.postCode ?? '';
    presentAddressController.text = p.presentAddress ?? '';
    permanentAddressController.text = p.permanentAddress ?? '';
    institutionTypeController.text = p.institutionType ?? '';
    cgpaController.text = p.honsGpa.toString();
    // institutionNameController.text = p.institutionName ?? '';
  }

  Future<void> saveProfile() async {
    final updated = UserProfile(
      id: userProfile.value?.id,
      fullName: fullNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      dateOfBirth: dobController.text.isNotEmpty
          ? DateTime.parse(dobController.text)
          : null,
      gender: genderController.text,
      division: divisionController.text,
      district: districtController.text,
      upzilla: upazillaController.text,
      postCode: postCodeController.text,
      presentAddress: presentAddressController.text,
      permanentAddress: permanentAddressController.text,
      institutionType: institutionTypeController.text,
      honsGpa: double.tryParse(cgpaController.text) ?? 0.0,
      // institutionName: institutionNameController.text,
    );

    // TODO: call your update API, then re-cache the result
    // final result = await _api.updateUserProfile(updated);
    // result.fold(
    //   (err) => Utils.showSnackbar(message: err.message, isSuccess: false),
    //   (fresh) {
    //     userProfile.value = fresh;
    //     StorageHelper.setUserData(fresh.toJson());
    //     Utils.showSnackbar(message: 'Profile saved!', isSuccess: true);
    //   },
    // );
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
