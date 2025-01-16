import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../subjects/models/subjects_model.dart';
import '../controller/custom_exam_controller.dart';

class CustomExamView extends GetView<CustomExamController> {
  const CustomExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Exam")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.customExamQuestions.value?.subjects != null) ...[
                  for (int i = 0; i < controller.customExamQuestions.value!.subjects!.length; i++)
                    buildSubjectCard(i),
                ],
                buildAddSubjectButton(),
              ],
            ),
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
                  value: controller.subjects
                      .firstWhereOrNull((s) => s.name == subject.subjectName),
                  decoration: InputDecoration(
                    hintText: "Select Subject",
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 12.h, horizontal: 16.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  items: controller.subjects
                      .map((subject) => DropdownMenuItem(
                            value: subject,
                            child: Text(subject.name),
                          ))
                      .toList(),
                  onChanged: (selectedSubject) {
                    if (selectedSubject != null) {
                      subject.subjectName = selectedSubject.name;
                      controller.fetchTopicsBySubjectId(selectedSubject.id);
                      controller.customExamQuestions.refresh();
                    }
                  },
                ),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () => controller.removeSubject(index),
                child: const Icon(Icons.delete, color: Colors.red),
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
    value: controller.topics.isNotEmpty && subject.topics![j]['topicName'] != null
        ? subject.topics![j]['topicName']
        : null, // Set value to null if no topics
    decoration: InputDecoration(
      hintText: "Select Topic",
      contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
    ),
    items: controller.topics.isNotEmpty
        ? controller.topics
            .map((topic) => DropdownMenuItem(
                  value: topic.name, // Use unique topic name
                  child: Text(topic.name),
                ))
            .toList()
        : [
            DropdownMenuItem(
              value: null,
              child: Text(
                "No Topics Available",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
    onChanged: (value) {
      if (value != null) {
        subject.topics![j]['topicName'] = value; // Update selected topic
        controller.customExamQuestions.refresh();
      }
    },
  ),
),


                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextFormField(
                          initialValue: subject.topics![j]['questionCount']
                              ?.toString(),
                          decoration: InputDecoration(
                            hintText: "Questions",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.h, horizontal: 16.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
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
              controller.addTopic(index, "New Topic", 0);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFA1A1A1),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Row(
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
