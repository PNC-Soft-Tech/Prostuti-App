import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/models/division_model.dart';
import 'package:prostuti/app/models/district_model.dart';
import 'package:prostuti/app/models/institution.dart';
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
  var allInstitutions = <Institution>[].obs;
  var institutions = <Institution>[].obs;

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
      displayLeaderboardRanks();
    }

    // listen to ranking type changes
    ever(selectedRankingType, _onRankingTypeChanged);
    ever(selectedInstitutionType, (_) => _filterInstitutions());

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
    // await StorageHelper.saveLatestContestId("67823db383ec486ffce545d6");
    contestId = await StorageHelper.getLatestContestId();
    if (contestId.isNotEmpty) {
      displayLeaderboardRanks();
    }
  }

  Future<void> displayLeaderboardRanks() async {
    isRankLoading.value = true;

    // prepare only the one filter that applies
    String? divisionParam;
    String? districtParam;
    String? upazilaParam;
    String? institutionTypeParam;

    switch (selectedRankingType.value) {
      case 'division':
        divisionParam = selectedDivision.value?.id;
        break;
      case 'district':
        districtParam = selectedDistrict.value?.id;
        break;
      case 'upazila':
        upazilaParam = selectedUpazila.value?.id;
        break;
      case 'institution':
        institutionTypeParam = selectedInstitutionType.value?.id;
        break;
      // for 'overall', leave all as null
    }

    final result = await _apiHelper.getLeaderboardRanks(
      contestId: contestId,
      division: divisionParam,
      district: districtParam,
      upazila: upazilaParam,
      institutionType: institutionTypeParam,
    );

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
      (list) {
        institutionTypes.value = list;
        ;
        _loadInstitutions();
      },
    );
  }

  Future<void> _loadInstitutions() async {
    final res = await _apiHelper.getInstitutions();
    res.fold(
      (err) => Utils.showSnackbar(message: err.message, isSuccess: false),
      (list) {
        allInstitutions.value = list;
        _filterInstitutions();
      },
    );
  }

  void _filterInstitutions() {
    final type = selectedInstitutionType.value;
    if (type != null) {
      institutions.value = allInstitutions
          .where((ins) => ins.institutionType?.id == type.id)
          .toList();
    } else {
      institutions.value = allInstitutions;
    }
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

  String get rankingTitle {
    switch (selectedRankingType.value) {
      case 'division':
        final name = selectedDivision.value?.name ?? '—';
        return 'Top 10 : $name';
      case 'district':
        final name = selectedDistrict.value?.name ?? '—';
        return 'Top 10 : $name';
      case 'upazila':
        final name = selectedUpazila.value?.name ?? '—';
        return 'Top 10 : $name';
      case 'institution':
        final name = selectedInstitutionName.value ?? '—';
        return 'Top 10 : $name';
      default:
        return 'Top 10 : Overall';
    }
  }
}
