import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/models/division_model.dart';
import 'package:prostuti/app/models/district_model.dart';
import 'package:prostuti/app/models/institution_type.dart';
import 'package:prostuti/app/models/upazila_model.dart';
import 'package:prostuti/app/modules/ranking/models/ranking_info.dart';
import 'package:prostuti/app/storage/storage_helper.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import '../../../APIs/api_helper.dart';

class RankingController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var contestRankData = Rxn<ContestData>();
  var isLoading = false.obs;
  var isRankLoading = false.obs;

  /// selected ranking type: 'overall', 'division', 'district', 'upazila', 'institution'
  var selectedRankingType = 'overall'.obs;

  /// Geography data
  var divisions = <Division>[].obs;
  var districts = <District>[].obs;
  var upazilas = <Upazila>[].obs;

  /// Institution types (from API)
  var institutionTypes = <InstitutionType>[].obs;

  /// Selected filters
  var selectedDivision = Rxn<Division>();
  var selectedDistrict = Rxn<District>();
  var selectedUpazila = Rxn<Upazila>();
  var selectedInstitutionType = Rxn<InstitutionType>();
  var selectedInstitutionName = Rxn<String>();

  late String contestId;

  @override
  void onInit() {
    super.onInit();

    // initial load of leaderboard
    contestId = Get.arguments ?? "";
    if (contestId.isEmpty) {
      _getContestIdFromSharedPreferences();
    } else {
      displayLeaderboardRanks(contestId);
    }

    // listen to ranking type changes
    ever(selectedRankingType, _onRankingTypeChanged);
    // trigger initial load for default 'overall'
    _onRankingTypeChanged(selectedRankingType.value);
  }

  void _onRankingTypeChanged(String type) {
    switch (type) {
      case 'division':
        if (divisions.isEmpty) {
          loadDivisions();
        }

        break;
      case 'district':
        if (districts.isEmpty) {
          loadDistricts();
        }
        break;
      case 'upazila':
        if (upazilas.isEmpty) {
          loadUpazilas();
        }
        break;
      case 'institution':
        loadInstitutionTypes();
        break;
      default:
        // no data load for 'overall'
        break;
    }
  }

  Future<void> _getContestIdFromSharedPreferences() async {
    await StorageHelper.saveLatestContestId("67823db383ec486ffce545d6");
    contestId = await StorageHelper.getLatestContestId();
    if (contestId.isNotEmpty) {
      displayLeaderboardRanks(contestId);
    }
  }

  Future<void> displayLeaderboardRanks(String contestId) async {
    isRankLoading.value = true;
    final result = await _apiHelper.getLeaderboardRanks(contestId);
    result.fold(
      (error) {
        isRankLoading.value = false;
        Utils.showSnackbar(
          message: 'Failed to fetch leaderboard: ${error.message}',
          isSuccess: false,
        );
      },
      (data) {
        isRankLoading.value = false;
        contestRankData.value = data;
      },
    );
  }

  Future<void> loadDivisions() async {
    final jsonStr =
        await rootBundle.loadString('assets/jsons/bd-divisions.json');
    final List<dynamic> data = json.decode(jsonStr);
    divisions.value = data.map((j) => Division.fromJson(j)).toList();
  }

  Future<void> loadDistricts() async {
    final jsonStr =
        await rootBundle.loadString('assets/jsons/bd-districts.json');
    final List<dynamic> data = json.decode(jsonStr);
    districts.value = data.map((j) => District.fromJson(j)).toList();
  }

  Future<void> loadUpazilas() async {
    final jsonStr =
        await rootBundle.loadString('assets/jsons/bd-upazilas.json');
    final List<dynamic> data = json.decode(jsonStr);
    upazilas.value = data.map((j) => Upazila.fromJson(j)).toList();
  }

  Future<void> loadInstitutionTypes() async {
    final res = await _apiHelper.getInstitutionTypes();
    res.fold(
      (err) => Utils.showSnackbar(message: err.message, isSuccess: false),
      (list) => institutionTypes.value = list,
    );
  }

  // Update ranking type from UI
  void updateRankingType(String type) {
    selectedRankingType.value = type;
  }

  // Update selected filter values
  void updateFilters({
    Division? division,
    District? district,
    Upazila? upazila,
    InstitutionType? institutionType,
    String? institutionName,
  }) {
    if (division != null) selectedDivision.value = division;
    if (district != null) selectedDistrict.value = district;
    if (upazila != null) selectedUpazila.value = upazila;
    if (institutionType != null) {
      selectedInstitutionType.value = institutionType;
    }
    if (institutionName != null) {
      selectedInstitutionName.value = institutionName;
    }
  }
}
