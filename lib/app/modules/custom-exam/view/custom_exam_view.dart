import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/common/custom_simple_appbar.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../constant/app_color.dart';
import '../../subjects/models/subjects_model.dart';
import '../controller/custom_exam_controller.dart';
import 'package:collection/collection.dart';

import '../models/custom_exam_subject_model.dart';
import 'preview_screen.dart';

class CustomExamView extends GetView<CustomExamController> {
  const CustomExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: CustomSimpleAppBar.appBar(title: "Custom Exam"),
      body: GetX<CustomExamController>(
        builder: (_) {
          if (controller.isLoading.value) {
            return const Center(child: CupertinoActivityIndicator(color: AppColors.primary));
          }
          
          if (controller.customExamQuestions.value == null || 
              controller.customExamQuestions.value!.subjects == null) {
            return const Center(child: Text("No exam data available"));
          }
          
          // Sanitize data to avoid null issues
          try {
            for (var subject in controller.customExamQuestions.value!.subjects!) {
              // Ensure subjectName is not null
              if (subject.subjectName == null) {
                subject.subjectName = "";
              }
              
              // Ensure each topic's properties are not null
              if (subject.topics != null) {
                for (var topic in subject.topics!) {
                  if (topic['topicName'] == null) {
                    topic['topicName'] = '';
                  }
                  if (topic['topic'] == null) {
                    topic['topic'] = '';
                  }
                  if (topic['questionCount'] == null) {
                    topic['questionCount'] = 1;
                  }
                }
              }
            }
          } catch (e) {
            log("Error sanitizing data: $e");
          }
          
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exam Type Selection
                      _buildExamTypeSelector(),
                      SizedBox(height: 16.h),
                      // Build subject cards
                      for (int i = 0; i < controller.customExamQuestions.value!.subjects!.length; i++)
                        buildSubjectCard(i),
                      buildAddSubjectButton(),
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton.button(
                      text: "Continue",
                      onPressed: () {
                        // Validate exam type selection
                        if (controller.selectedExamTypeId.value.isEmpty) {
                          Utils.showSnackbar(
                            message: "Please select a job category first",
                            isSuccess: false
                          );
                          return;
                        }

                        final Map<String, List<Map<String, dynamic>>> previewData = {};
                        
                        for (var subject in controller.customExamQuestions.value!.subjects!) {
                          if (subject.subjectName != null && subject.subjectName!.isNotEmpty && 
                              subject.topics != null) {
                            previewData[subject.subjectName!] = subject.topics!;
                          }
                        }
                        
                        if (previewData.isNotEmpty) {
                          Get.to(() => PreviewScreen(subjectsData: previewData));
                        } else {
                          Utils.showSnackbar(
                            message: "Please add at least one subject with a topic",
                            isSuccess: false
                          );
                        }
                      },
                      mainAxisSize: MainAxisSize.max
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSubjectCard(int index) {
    try {
      // Ensure subjects and the specific subject at this index exist
      if (controller.customExamQuestions.value?.subjects == null ||
          index >= controller.customExamQuestions.value!.subjects!.length) {
        return const SizedBox.shrink();
      }
      
      final subject = controller.customExamQuestions.value!.subjects![index];

      return Card(
        color: Colors.white,
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
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      value: controller.subjects.isNotEmpty
                          ? controller.subjects.firstWhereOrNull(
                              (s) => s.name == subject.subjectName)
                          : null,
                      decoration: InputDecoration(
                        hintText: "Select Subject",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 16.w),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0.5, color: Color(0xff212d4066)),
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
                          // Since 'id' is final, we need to replace the entire subject instead of updating it directly
                          final oldSubject = subject;
                          
                          // Create a new CustomExamSubject with the selected subject's details
                          final newSubject = CustomExamSubject(
                            id: selectedSubject.id,
                            subjectName: selectedSubject.name,
                            topics: [], // Start with empty topics list
                          );
                          
                          // Find the index of the current subject in the list and replace it
                          final subjectIndex = controller.customExamQuestions.value!.subjects!.indexOf(oldSubject);
                          if (subjectIndex >= 0) {
                            controller.customExamQuestions.value!.subjects![subjectIndex] = newSubject;
                          }
                          
                          controller.selectedSubjectId.value = selectedSubject.id;
                          
                          // Fetch topics for this specific subject
                          controller.fetchTopicsBySubjectId(selectedSubject.id).then((_) {
                            final newTopics = controller.subjectTopicsMap[selectedSubject.id] ?? [];
                            
                            if (newTopics.isNotEmpty) {
                              // Create a new topic from the first available topic
                              final firstTopic = newTopics.first;
                              
                              // Fetch count for this topic
                              controller.fetchQuestionCountForTopic(firstTopic.id);
                              
                              // Add the first topic to the subject
                              newSubject.topics ??= [];
                              newSubject.topics!.add({
                                'topic': firstTopic.id,
                                'topicName': firstTopic.name ?? '',
                                'questionCount': 1,
                              });
                            } else {
                              Utils.showSnackbar(
                                message: "No topics available for this subject",
                                isSuccess: false
                              );
                            }
                            
                            // Notify UI to update
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
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(50.r),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0.5, color: Color(0xff212d4066)),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              isExpanded: true,
                              value: findTopicDropdownValue(index, j),
                              items: (subject.id != null ? controller.subjectTopicsMap[subject.id] ?? [] : [])
                                  .map<DropdownMenuItem<String>>((topic) => 
                                    DropdownMenuItem(
                                      value: topic.name,
                                      child: Text(topic.name ?? "Unnamed Topic"),
                                    )
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null && subject.topics != null && j < subject.topics!.length && subject.id != null) {
                                  // Remove previously selected topic from selectedTopics
                                  final previousTopic = subject.topics![j]['topicName'];
                                  if (previousTopic != null) {
                                    controller.selectedTopics[index]?.remove(previousTopic);
                                  }
                                  
                                  // Find the topic object from subjectTopicsMap to get its ID
                                  final selectedTopicObj = controller.subjectTopicsMap[subject.id]?.firstWhereOrNull(
                                    (topic) => topic.name == value
                                  );
                                  
                                  if (selectedTopicObj != null) {
                                    // Add the new topic to selectedTopics
                                    subject.topics![j]['topicName'] = value;
                                    subject.topics![j]['topic'] = selectedTopicObj.id;
                                    
                                    // Fetch question count for the newly selected topic
                                    if (selectedTopicObj.id != null && selectedTopicObj.id.isNotEmpty) {
                                      controller.fetchQuestionCountForTopic(selectedTopicObj.id);
                                    }
                                    
                                    controller.selectedTopics[index] ??= [];
                                    controller.selectedTopics[index]!.add(value);
                                    
                                    controller.customExamQuestions.refresh();
                                  }
                                }
                              },
                              hint: Text(
                                controller.topics.isEmpty ? "No Topics Available" : "Select Topic"
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            flex: 1,
                            child: FutureBuilder(
                              future: subject.topics?[j]?['topic'] != null 
                                ? controller.fetchQuestionCountForTopic(subject.topics![j]['topic'].toString())
                                : null,
                              builder: (context, snapshot) {
                                String topicId = '';
                                if (subject.topics?[j]?['topic'] != null) {
                                  topicId = subject.topics![j]['topic'].toString();
                                }
                                final available = controller.getAvailableQuestionCount(topicId);
                                final current = subject.topics?[j]?['questionCount'] ?? 1;
                                final isExceeded = current > available;
                                
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropdownButtonFormField<int>(
                                      value: isExceeded ? 1 : (current > 0 ? current : 1),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(width: 0.5, color: Color(0xff212d4066)),
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        hintText: "Count",
                                      ),
                                      items: [
                                        for (int i = 1; i <= (available > 0 ? available : 1); i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text("$i"),
                                          )
                                      ],
                                      onChanged: (value) {
                                        if (value != null && subject.topics != null && j < subject.topics!.length) {
                                          subject.topics![j]['questionCount'] = value;
                                          controller.customExamQuestions.refresh();
                                        }
                                      },
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Available: $available",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: isExceeded ? Colors.red : Colors.grey,
                                        fontWeight: isExceeded ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                );
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
    } catch (e) {
      // Catch any exceptions and show error message
      log("Error in build: $e");
      return Center(child: Text("An error occurred: $e"));
    }
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

  String? findTopicDropdownValue(int index, int j) {
    final subject = controller.customExamQuestions.value?.subjects?[index];
    if (subject == null || subject.topics == null || j >= subject.topics!.length) {
      return null;
    }
    
    final topicName = subject.topics![j]['topicName'] as String?;
    if (topicName == null) {
      return null;  // Return null explicitly if topicName is null
    }
    
    // Check if the topic name exists in the available topics
    final topics = controller.subjectTopicsMap[subject.id] ?? [];
    final exists = topics.any((t) => t.name == topicName);
    
    return exists ? topicName : null;
  }

  Widget _buildExamTypeSelector() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.work_outline,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Select Job Category',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Obx(() {
              if (controller.isLoadingExamTypes.value) {
                return const Center(
                  child: CupertinoActivityIndicator(color: AppColors.primary),
                );
              }

              if (controller.examTypes.isEmpty) {
                return Text(
                  'No job categories available',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose the job category for your custom exam:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Exam Type Dropdown
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedExamTypeId.value.isNotEmpty 
                            ? controller.selectedExamTypeId.value 
                            : null,
                        hint: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            'Select a job category',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        items: controller.examTypes.map((examType) {
                          return DropdownMenuItem<String>(
                            value: examType.id,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                examType.title,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textPrimaryColor,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            final selectedExamType = controller.examTypes
                                .firstWhere((examType) => examType.id == newValue);
                            controller.selectExamType(
                              newValue, 
                              selectedExamType.title
                            );
                          }
                        },
                        isExpanded: true,
                        icon: Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Selected exam type display
                  if (controller.selectedExamTypeName.value.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 16.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Selected: ${controller.selectedExamTypeName.value}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
