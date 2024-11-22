import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/routes/app_pages.dart';

import '../../../common/models/contest_model.dart';


class ContestWidget extends StatelessWidget {
  final Contest contest;

  ContestWidget(this.contest);

  @override
  Widget build(BuildContext context) {
    return  Card(
        elevation: 2.3,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(contest.name),
          subtitle: Text(contest.description),
          trailing: Text('${contest.totalMarks} Marks'),
          onTap: () {
           log("clicked ${contest.id}");
         Get.toNamed(Routes.singleContest(contest.id));
          },
        ),
      );
    
  }
}
