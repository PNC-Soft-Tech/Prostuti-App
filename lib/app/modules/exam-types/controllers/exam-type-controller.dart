import 'package:get/get.dart';
import '../../../APIs/api_helper_implementation.dart';
import '../models/exam-type-model.dart';


class ExamTypeController extends GetxController {
  final ApiHelperImpl _apiHelper = ApiHelperImpl();
  var examTypes = <ExamType>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchExamTypes();
    super.onInit();
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
