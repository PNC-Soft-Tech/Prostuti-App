  import 'package:get/get.dart';

import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';
import '../models/exam_topics_model.dart';

class ExamTopicsController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;
  var subCategories = <SubjectTopics>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> _checkAuthAndFetchSubCategories(String categoryId) async {
    final hasAccess = await _authService.checkFeatureAccess(
      featureName: 'exam_topics',
      customMessage: 'Please log in to access exam topics',
    );
    
    if (hasAccess) {
      await _fetchSubCategories(categoryId);
    }
  }

  Future<void> _fetchSubCategories(String categoryId) async {
    isLoading(true);
    final result = await _apiHelper.fetchSubCategoriesByCategoryId(categoryId);    result.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (data) {
        subCategories.assignAll(data);
      },
    );
    isLoading(false);
  }

  void fetchSubCategories(String categoryId) async {
    await _checkAuthAndFetchSubCategories(categoryId);
  }
}