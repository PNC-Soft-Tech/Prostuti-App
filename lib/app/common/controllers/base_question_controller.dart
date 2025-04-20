import 'package:get/get.dart';

abstract class BaseQuestionController extends GetxController {
  bool isMarkedQuestion(String questionId);
  void markUnmarkQuestion(String questionId);
  void selectOption(String questionId, String selectedOptionOrder);
  bool isOptionSelected(String questionId, String optionOrder);
  Future<bool> submitAnswer(String questionId, String contestId, String selectedAnswer);
  String getOptionAns(int index);
}
