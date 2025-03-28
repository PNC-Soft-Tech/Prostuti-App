import 'package:get/get.dart';
import 'package:prostuti/app/modules/ranking/controllers/ranking_controller.dart';
import '../../contests/controller/contest_controller.dart';
import '../../job-circulars/controllers/job-circulars-controller.dart';
import '../../model-tests-details/controllers/model_test_details_controller.dart';
import '../../model-tests/controller/model_test_controller.dart';
import '../../search-page/controller/search_controller.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContestController>(() => ContestController());
    Get.lazyPut<ModelTestController>(() => ModelTestController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<JobCircularController>(() => JobCircularController());
    Get.lazyPut<SearchPageController>(() => SearchPageController());
    Get.lazyPut<RankingController>(() => RankingController());
  }
}
