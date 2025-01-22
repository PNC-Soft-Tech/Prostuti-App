import 'package:get/get.dart';
import 'package:prostuti/app/modules/ranking/models/ranking_info.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';

class RankingController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var ranking = Rxn<RankingInfo>();
  var isLoading = false.obs;
  var isRankLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    displayLeaderboardRanks("67823db383ec486ffce545d6");
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

        ranking.value = rankingData;
        print('\n\n\n\nRank Contest Title: ');
        print(ranking.value?.contestTitle);
      },
    );
  }
}
