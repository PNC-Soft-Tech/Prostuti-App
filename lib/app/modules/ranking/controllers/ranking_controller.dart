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
}
