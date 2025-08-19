// lib/common/controllers/base_question_controller.dart

import 'package:get/get.dart';

abstract class BaseQuestionController extends GetxController {
  // Common state properties
  RxMap<String, List<String>> get selectedAnswers;
  RxList<String> get markedQuestionIds;
  RxBool get isQuestionOpened;
  RxString get selectedSubject;
  RxString get selectedTestMode;
  RxBool get isModelTestSubmitted;
  
  // Navigation methods
  void scrollToQuestion(String questionId);
  String? getNextVisibleQuestion(String currentQuestionId);
  String? getPreviousVisibleQuestion(String currentQuestionId);
  
  // Question interaction methods
  bool isMarkedQuestion(String questionId);
  void markUnmarkQuestion(String questionId);
  void selectOption(String questionId, String selectedOptionId);
  bool isOptionSelected(String questionId, String optionId);
    bool isCorrectAnswered (String questionId, String selectedAnswer) ;
  bool isAnswered(String questionId, String optionId) ;
  Future<bool> submitAnswer(String questionId, String contestId, List<String> selectedAnswers);
  String getOptionAns(int index);
  void resetSelectOption(String questionId) ;
}