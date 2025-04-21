// lib/common/controllers/base_question_controller.dart

import 'package:get/get.dart';

abstract class BaseQuestionController extends GetxController {
  // Common state properties
  RxMap<String, String> get selectedAnswers;
  RxList<String> get markedQuestionIds;
  RxBool get isQuestionOpened;
  RxString get selectedSubject;
  
  // Navigation methods
  void scrollToQuestion(String questionId);
  String? getNextVisibleQuestion(String currentQuestionId);
  String? getPreviousVisibleQuestion(String currentQuestionId);
  
  // Question interaction methods
  bool isMarkedQuestion(String questionId);
  void markUnmarkQuestion(String questionId);
  void selectOption(String questionId, String selectedOptionOrder);
  bool isOptionSelected(String questionId, String optionOrder);
  Future<bool> submitAnswer(String questionId, String contestId, String selectedAnswer);
  String getOptionAns(int index);
}