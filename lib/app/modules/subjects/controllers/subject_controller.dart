import 'package:get/get.dart';

import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';
import '../models/subjects_model.dart';

class CategoryController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;
  var subjects = <Subjects>[].obs;
  Future<void> fetchCategories() async {
    final hasAccess = await _authService.checkFeatureAccess(
      featureName: 'subjects',
      customMessage: 'Please log in to view subjects',
    );
    
    if (!hasAccess) {
      return;
    }

    isLoading(true);
    final result = await _apiHelper.fetchSubjects();
    result.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (data) {
        subjects.assignAll(data);
      },
    );
    isLoading(false);
  }
}
