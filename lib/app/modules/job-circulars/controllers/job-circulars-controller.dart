import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../models/job-circulars-model.dart';

class JobCircularController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var isLoading = false.obs;
  var jobCirculars = <JobCircular>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobCirculars();
  }

  void fetchJobCirculars() async {
    isLoading(true);
    final result = await _apiHelper.fetchJobCirculars();
    result.fold(
      (error) {
        Get.snackbar('Error', error.message ?? 'Failed to load job circulars');
      },
      (data) {
        jobCirculars.assignAll(data);
      },
    );
    isLoading(false);
  }
}
