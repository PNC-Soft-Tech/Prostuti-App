import 'package:get/get.dart';
import 'package:prostuti/app/modules/ranking/models/ranking_info.dart';
import 'package:prostuti/app/storage/storage_helper.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';

class RankingController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var contestRankData = Rxn<ContestData>();
  var isLoading = false.obs;
  var isRankLoading = false.obs;

  // Store the selected filters as Rx variables
  var selectedRankingType = 'overall'.obs; // Default value is 'overall'
  var selectedDivision = Rxn<String>();
  var selectedDistrict = Rxn<String>();
  var selectedUpazila = Rxn<String>();
  var selectedInstitutionType = Rxn<String>();
  var selectedInstitutionName = Rxn<String>();

  late String contestId; // the contest ID

  @override
  void onInit() {
    super.onInit();

    contestId = Get.arguments ?? "";

    if (contestId.isEmpty) {
      _getContestIdFromSharedPreferences();
    } else {
      displayLeaderboardRanks(contestId);
    }
  }

  Future<void> _getContestIdFromSharedPreferences() async {
    await StorageHelper.saveLatestContestId("67823db383ec486ffce545d6");
    contestId = await StorageHelper.getLatestContestId();
    if (contestId.isNotEmpty) {
      displayLeaderboardRanks(contestId);
    } else {
      print('No contestId found in SharedPreferences.');
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
      (rankingData) {
        isRankLoading.value = false;

        contestRankData.value = rankingData;
      },
    );
  }

  // Update the selected ranking type
  void updateRankingType(String type) {
    selectedRankingType.value = type;
  }

  // Update the selected division, district, upazila, institution type, and name
  void updateFilters({
    String? division,
    String? district,
    String? upazila,
    String? institutionType,
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
