import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../models/exam_type_model.dart';

class ExamTypeController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

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
