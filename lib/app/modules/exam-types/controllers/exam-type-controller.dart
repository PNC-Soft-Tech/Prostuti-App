import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';
import '../models/exam_type_model.dart';

class ExamTypeController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AuthService _authService = Get.find<AuthService>();

  var examTypes = <ExamType>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthAndLoadExamTypes();
  }
  void _checkAuthAndLoadExamTypes() async {
    final hasAccess = await _authService.checkFeatureAccess(
      featureName: 'exam types',
      customMessage: 'Please log in to view exam types',
    );
    
    if (hasAccess) {
      fetchExamTypes();
    } else {
      isLoading.value = false;
    }
  }

  void fetchExamTypes() async {
    isLoading.value = true;
    final response = await _apiHelper.getExamTypes();
    response.fold(
      (error) {
        isLoading.value = false;
        Get.snackbar("Error", error.message);
      },
      (types) {
        examTypes.value = types;
        isLoading.value = false;
      },
    );
  }
}
