  import 'package:get/get.dart';

import '../../../APIs/api_helper.dart';
import '../models/exam_topics_model.dart';

final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var isLoading = false.obs;
  var subCategories = <SubjectTopics>[].obs;
// @override
// void onInit() {
//   super.onInit();

// }
  void fetchSubCategories(String categoryId) async {
    isLoading(true);
    final result = await _apiHelper.fetchSubCategoriesByCategoryId(categoryId);
    result.fold(
      (error) {
        Get.snackbar('Error', error.message ?? 'Failed to load subcategories');
      },
      (data) {
        subCategories.assignAll(data);
      },
    );
    isLoading(false);
  }