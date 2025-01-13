import 'dart:developer';

import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../contests/models/contest_model.dart';
import '../../subjects/controllers/subject_controller.dart';
import '../models/custom_exam_model.dart';
import '../models/custom_exam_subject_model.dart';

class CustomExamController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final CategoryController categoryController = Get.find<CategoryController>();

  var contests = <Contest>[].obs;
    var contest = Rxn<Contest>();
  var isLoading = false.obs;
Rxn<CustomExamModel> customExamQuestions = Rxn<CustomExamModel>();
Rxn<CustomExamSubject> customExamSubject = Rxn<CustomExamSubject>();
  @override
  void onInit() {
    super.onInit();
  categoryController.fetchCategories();
  }
void addTopic({
  required String id,
  required String subName,
  required String topicId,
  required int question,
}) {
  // Create a new CustomExamSubject object
  CustomExamSubject sub = CustomExamSubject(
    id: id,
    question: question,
    subjectName: subName,
    topic: topicId,
  );

  // Check if customExamQuestions.value is null
  if (customExamQuestions.value == null) {
    customExamQuestions.value = CustomExamModel(id: 'some-id', subjects: []);
  }

  // Ensure the subjects list is initialized
  if (customExamQuestions.value!.subjects == null) {
    customExamQuestions.value!.subjects = [];
  }

  // Add the new subject
  customExamQuestions.value!.subjects!.add(sub);

  // Log the updated length
  log("Topic added: ${sub.question}");
  log("Topic added qs: ${customExamQuestions.value?.subjects?.length}");
}

}
