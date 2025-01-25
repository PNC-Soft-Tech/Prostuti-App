import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/common/custom_simple_appbar.dart';
import '../../subjects/models/subjects_model.dart';
import '../controller/custom_exam_controller.dart';
import 'package:collection/collection.dart';

class CustomExamView extends GetView<CustomExamController> {
  const CustomExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar.appBar(title: "Custom Exam"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.customExamQuestions.value?.subjects != null) ...[
                      for (int i = 0;
                          i <
                              controller
                                  .customExamQuestions.value!.subjects!.length;
                          i++)
                        buildSubjectCard(i),
                    ],
                    buildAddSubjectButton(),
                    SizedBox(height: 80.h,)
                  ],
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton.button(text: "Continue", onPressed: (){
                    Get.toNamed('/custom_exam');
                  }, mainAxisSize: MainAxisSize.max),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget buildSubjectCard(int index) {
    final subject = controller.customExamQuestions.value!.subjects![index];

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<Subjects>(
                    isExpanded:
                        true, // Ensures the dropdown uses all available horizontal space

                    value: controller.subjects
                        .firstWhereOrNull((s) => s.name == subject.subjectName),
                    decoration: InputDecoration(
                      hintText: "Select Subject",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 16.w),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.5, color: Color(0xFF212D4066)),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    items: controller.subjects
                        .where(
                            (s) => !controller.selectedSubjects.contains(s.id))
                        .map((subject) => DropdownMenuItem(
                              value: subject,
                              child: Text(subject.name),
                            ))
                        .toList(),
                    onChanged: (selectedSubject) {
                      if (selectedSubject != null) {
                        subject.subjectName = selectedSubject.name;
                        controller.selectedSubjectId.value = selectedSubject.id;
                        // controller.fetchTopicsBySubjectId(selectedSubject.id);
                        subject.topics = [];
                        // controller.customExamQuestions.refresh();
                        // Fetch topics for the newly selected subject
                        controller
                            .fetchTopicsBySubjectId(selectedSubject.id)
                            .then((_) {
                          // Fetch topics for the selected subject
                          final newTopics =
                              controller.subjectTopicsMap[selectedSubject.id] ??
                                  [];
                          controller.selectedTopics[index]?.map((t) {
                            log(" old topics: ${t}");
                          });
                          log(" new topic: ${newTopics.first.name}");
                          // Add only the first topic if available
                          subject.topics = newTopics.isNotEmpty
                              ? [
                                  {
                                    'topicName': newTopics.first.name,
                                    'questionCount':
                                        null, // Reset question count for the first topic
                                  }
                                ]
                              : []; // No topics if the list is empty

                          // Refresh custom exam data
                          controller.customExamQuestions.refresh();
                        });
                      }
                    },
                    hint: const Text("Select Subject"),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () => controller.removeSubject(index),
                  child: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Topics List
            if (subject.topics != null && subject.topics!.isNotEmpty)
              Column(
                children: [
                  for (int j = 0; j < subject.topics!.length; j++) ...[
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            borderRadius: BorderRadius.circular(50.r),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0.5, color: Color(0xFF212D4066)),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),

                            isExpanded:
                                true, // Ensures the dropdown uses all available horizontal space
                            // value: subject.topics != null ? subject.topics![j]['topicName'] : null,
                            value: (controller
                                            .subjectTopicsMap[controller
                                                .selectedSubjectId.value]
                                            ?.length ??
                                        0) >
                                    j
                                ? controller
                                    .subjectTopicsMap[
                                        controller.selectedSubjectId.value]![j]
                                    .name
                                : null,

                            //       items:  [DropdownMenuItem(
                            //             value: 'Physics',
                            //             child: Text('Physicss'),

                            //  )],
                            items: (controller.subjectTopicsMap[
                                        controller.selectedSubjectId.value] ??
                                    [])
                                .map<DropdownMenuItem<String>>(
                                    (topic) => DropdownMenuItem(
                                          value: topic
                                              .name, // Ensure value is unique and matches topic.name
                                          child: Text(topic
                                              .name), // Display the topic name in the dropdown
                                        ))
                                .toList(),

                            // items: (controller.subjectTopicsMap[controller.selectedSubjectId.value] ??
                            //         [])
                            //     .where((topic) {
                            //       final isAlreadySelected = subject.topics?.any(
                            //               (t) =>
                            //                   t['topicName'] == topic.name) ??
                            //           false;
                            //       return !isAlreadySelected;
                            //     })
                            //     .map((topic) => DropdownMenuItem(
                            //           value: topic.name,
                            //           child: Text(topic.name),
                            //         ))
                            //     .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                // Remove previously selected topic from selectedTopics
                                final previousTopic =
                                    subject.topics![j]['topicName'];
                                if (previousTopic != null) {
                                  controller.selectedTopics[index]
                                      ?.remove(previousTopic);
                                }

                                // Add the new topic to selectedTopics
                                subject.topics![j]['topicName'] = value;
                                controller.selectedTopics[index] ??= [];
                                controller.selectedTopics[index]!.add(value);

                                controller.customExamQuestions.refresh();
                              }
                            },
                            hint: Text(controller.topics.isEmpty
                                ? "No Topics Available"
                                : "Select Topic"),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue:
                                subject.topics![j]['questionCount']?.toString(),
                            decoration: InputDecoration(
                              hintText: "Questions",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 16.w),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0.5, color: Color(0xFF212D4066)),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              subject.topics![j]['questionCount'] =
                                  int.tryParse(value);
                              controller.customExamQuestions.refresh();
                            },
                          ),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () => controller.removeTopic(index, j),
                          child: const Icon(Icons.remove_circle_outline,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],
                ],
              ),

            // Add Topic Button
            GestureDetector(
              onTap: () {
                controller.addTopic(index);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFA1A1A1),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 5.w),
                    Text(
                      "Add Topic",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddSubjectButton() {
    return GestureDetector(
      onTap: controller.addSubject,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: const Color(0xFF50BDB4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Colors.white),
            SizedBox(width: 5.w),
            Text(
              "Add Subject",
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
