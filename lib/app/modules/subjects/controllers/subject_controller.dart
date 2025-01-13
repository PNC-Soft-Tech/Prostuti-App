import 'package:get/get.dart';

import '../../../APIs/api_helper.dart';
import '../models/subjects_model.dart';

class CategoryController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var isLoading = false.obs;
  var subjects = <Subjects>[].obs;

  void fetchCategories() async {
    isLoading(true);
    final result = await _apiHelper.fetchSubjects();
    result.fold(
      (error) {
        Get.snackbar('Error', error.message ?? 'Failed to load subjects');
      },
      (data) {
        subjects.assignAll(data);
      },
    );
    isLoading(false);
  }
}
