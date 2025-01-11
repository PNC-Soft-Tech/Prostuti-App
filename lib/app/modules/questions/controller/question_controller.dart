import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../models/question_model.dart';

class QuestionController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var questions = <Question>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    isLoading(true);
    final result = await _apiHelper.fetchAllQuestions();
    result.fold(
      (error) {
        Get.snackbar('Error', error.message ?? 'Failed to load questions');
      },
      (data) {
        questions.assignAll(data);
      },
    );
    isLoading(false);
  }
}
