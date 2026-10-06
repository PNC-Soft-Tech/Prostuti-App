import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';
import '../models/question_model.dart';

class QuestionController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AuthService _authService = Get.find<AuthService>();

  var questions = <Question>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthAndLoadQuestions();
  }

  /// Check authentication and load questions if authenticated
  void _checkAuthAndLoadQuestions() async {
    final hasAccess = await _authService.checkFeatureAccess(
      featureName: 'question bank',
      customMessage: 'Please login to access the question bank and practice questions.',
    );
    
    if (hasAccess) {
      fetchQuestions();
    }
  }  Future<void> fetchQuestions() async {
    isLoading(true);
    final result = await _apiHelper.fetchAllQuestions();
    result.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (data) {
        questions.assignAll(data);
      },
    );
    isLoading(false);
  }
}
