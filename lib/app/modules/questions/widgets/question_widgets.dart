import 'package:flutter/material.dart';
import '../../../common/models/question_model.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;

  QuestionWidget(this.question);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(question.title),
        subtitle: Text('Correct Answer: ${question.rightAnswer}'),
        onTap: () {
          // Handle onTap logic, e.g., navigate to question details
        },
      ),
    );
  }
}
