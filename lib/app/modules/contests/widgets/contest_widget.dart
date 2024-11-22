import 'package:flutter/material.dart';

import '../../../common/models/contest_model.dart';


class ContestWidget extends StatelessWidget {
  final Contest contest;

  ContestWidget(this.contest);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(contest.name),
        subtitle: Text(contest.description),
        trailing: Text('${contest.totalMarks} Marks'),
        onTap: () {
          // Handle onTap logic, e.g., navigate to contest details
        },
      ),
    );
  }
}
