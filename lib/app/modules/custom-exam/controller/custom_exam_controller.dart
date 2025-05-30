import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../routes/app_pages.dart';
import '../../exam-topics/models/exam_topics_model.dart';
import '../../contests/models/topics_model.dart';
import '../models/custom_exam_model.dart';
import '../models/custom_exam_request_model.dart';
import '../models/custom_exam_subject_model.dart';
import '../../subjects/models/subjects_model.dart';

class CustomExamController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;
  RxList<Subjects> subjects = <Subjects>[].obs;
  RxList<SubjectTopics> topics = <SubjectTopics>[].obs;
  RxList<String> selectedSubjects = <String>[].obs;
  RxString selectedSubjectId = ''.obs;
  RxMap<int, List<String>> selectedTopics = <int, List<String>>{}
      .obs; // Map to track selected topics for each subject
  
  // Map to store available question count for each topic
  RxMap<String, int> topicQuestionCounts = <String, int>{}.obs;

  // Reactive custom exam model
  Rxn<CustomExamModel> customExamQuestions = Rxn<CustomExamModel>();
  RxMap<String, List<SubjectTopics>> subjectTopicsMap =
      <String, List<SubjectTopics>>{}.obs;
  @override
  void onInit() {
    super.onInit();

    // Initialize with a default empty model
    customExamQuestions.value = CustomExamModel(
      id: 'exam-1',
      subjects: [],
    );

    // Check authentication before fetching subjects
    _checkAuthAndLoadSubjects();
  }
  void _checkAuthAndLoadSubjects() async {
    final hasAccess = await _authService.checkFeatureAccess(
      featureName: 'custom exams',
      customMessage: 'Please log in to create custom exams',
    );
    
    if (!hasAccess) {
      return;
    }

    // Fetch subjects when the controller is initialized
    fetchSubjects().then((_) {
      if (subjects.isNotEmpty) {
        final firstSubject = subjects.first;

        // Fetch topics for the first subject and initialize exam data after fetching topics
        fetchTopicsBySubjectId(firstSubject.id).then((_) {
          // Initialize the custom exam data with the first subject and its topics
          selectedSubjectId.value = firstSubject.id;
          
          customExamQuestions.value = CustomExamModel(
            id: 'exam-1',
            subjects: [              CustomExamSubject(
                id: firstSubject.id, // Use API-provided ID
                subjectName: firstSubject.name, // Remove null check as it's non-nullable
                topics: [], // Initialize with empty list
              ),
            ],
          );

          customExamQuestions.refresh();
          log("Initialized custom exam with subject ${firstSubject.name} and ID ${firstSubject.id}");
        });
      }
    });
  }

// @override
// void onReady(){
//   super.onReady();
//   log(" already data: ${}");
// }
  Future<void> fetchSubjects() async {
    isLoading.value = true;
    final result = await _apiHelper.fetchSubjects();
    result.fold(
      (error) {
        log('Error fetching subjects: ${error.message}');
      },
      (data) {
        subjects.value = data;
        selectedSubjectId.value = data.first.id;
        log('Fetched ${subjects.length} subjects');
      },
    );
    isLoading.value = false;
  }

  Future<void> fetchTopicsBySubjectId(String subjectId) async {
    log("Fetching topics for subject ID: $subjectId");
    
    final result = await _apiHelper.fetchSubCategoriesByCategoryId(subjectId);
    result.fold(
      (error) {
        log('Error fetching topics: ${error.message}');
        subjectTopicsMap[subjectId] = []; // Empty list for failed fetch
      },
      (data) {
        subjectTopicsMap[subjectId] = data; // Store topics for this subject
        log('Fetched ${data.length} topics for subject $subjectId');
        
        // Preload question counts for all topics of this subject
        for (var topic in data) {
          fetchQuestionCountForTopic(topic.id);
        }
      },
    );
  }

  void addSubject() {
    customExamQuestions.value ??= CustomExamModel(id: 'exam-1', subjects: []);

    // Get the first available subject from the controller.subjects list
    if (subjects.isNotEmpty) {
      final selectedSubject = subjects.first;

      // Add the subject using its API-provided id
      customExamQuestions.value!.subjects?.add(        CustomExamSubject(
          id: selectedSubject.id, // Use the API-provided id
          subjectName: selectedSubject.name, // Remove null check as it's non-nullable
          topics: [], // Initialize with empty list to avoid null
        ),
      );

      customExamQuestions.refresh();
      log("Added a new subject. Total: ${customExamQuestions.value?.subjects?.length}");
    } else {
      log("No subjects available to add.");
      Utils.showSnackbar(message: "No subjects available to add", isSuccess: false);
    }
  }

  void addTopic(int subjectIndex) {
    if (customExamQuestions.value?.subjects != null &&
        subjectIndex < customExamQuestions.value!.subjects!.length) {
      CustomExamSubject subject =
          customExamQuestions.value!.subjects![subjectIndex];

      // Ensure we have the correct topics map using subject.id instead of selectedSubjectId
      if (subject.id == null || subject.id!.isEmpty) {
        log("Subject ID is missing");
        Utils.showSnackbar(message: "Subject ID is missing", isSuccess: false);
        return;
      }

      // Ensure we have topics for this subject
      if (subjectTopicsMap[subject.id] == null || subjectTopicsMap[subject.id]!.isEmpty) {
        log("No topics available for subject ${subject.id}");
        Utils.showSnackbar(message: "No topics available for this subject", isSuccess: false);
        return;
      }

      final availableTopics = subjectTopicsMap[subject.id]?.where((topic) {
        final isAlreadySelected =
            subject.topics?.any((t) => t['topic'] == topic.id) ?? false;
        log("Topic ${topic.name} isAlreadySelected: $isAlreadySelected");
        return !isAlreadySelected;
      }).toList();

      log("Available topics for subject ${subject.id}: ${availableTopics?.map((e) => e.name).toList()}");

      if (availableTopics != null && availableTopics.isNotEmpty) {
        subject.topics ??= [];
          // Get the selected topic
        final selectedTopic = availableTopics.first;
        
        // Fetch the question count for this topic
        if (selectedTopic.id.isNotEmpty) {
          fetchQuestionCountForTopic(selectedTopic.id);
        }
        
        // Store both topic id and topic name for reference.
        subject.topics!.add({
          'topic': selectedTopic.id, // Remove null check as it's non-nullable
          'topicName': selectedTopic.name, // Remove null check as it's non-nullable
          'questionCount': 1,
        });

        customExamQuestions.refresh();
        log("Added topic '${selectedTopic.name}' with 1 question to subject at index $subjectIndex.");
      } else {
        log("No available topics to add for subject at index $subjectIndex.");
        Utils.showSnackbar(message: "All topics for this subject have been added", isSuccess: false);
      }
    }
  }
  // Fetch and store the available question count for a topic
  Future<void> fetchQuestionCountForTopic(String topicId) async {
    if (topicId.isEmpty) {
      log('Cannot fetch question count for empty topic ID');
      return;
    }
    
    try {
      final result = await _apiHelper.fetchQuestionCountByTopicId(topicId);
      result.fold(
        (error) {
          log('Error fetching question count for topic $topicId: ${error.message}');
          // Default to 0 if there was an error
          topicQuestionCounts[topicId] = 0;
        },
        (count) {
          // Store the count in our map
          topicQuestionCounts[topicId] = count;
          log('Topic $topicId has $count available questions');
        },
      );
    } catch (e) {
      log('Exception when fetching question count: $e');
      // Default to 0 if there was an exception
      topicQuestionCounts[topicId] = 0;
    }
  }
  
  // Get the available question count for a topic
  int getAvailableQuestionCount(String topicId) {
    return topicQuestionCounts[topicId] ?? 0;
  }
  
  // Check if the requested question count is available for a topic
  bool isQuestionCountAvailable(String topicId, int requestedCount) {
    final availableCount = topicQuestionCounts[topicId] ?? 0;
    return requestedCount <= availableCount;
  }

  void removeSubject(int subjectIndex) {
    if (customExamQuestions.value?.subjects != null &&
        subjectIndex < customExamQuestions.value!.subjects!.length) {
      final removedSubject =
          customExamQuestions.value!.subjects!.removeAt(subjectIndex);

      // Remove the subject from the selected list
      if (removedSubject.subjectName != null) {
        selectedSubjects.removeWhere((id) =>
            subjects
                .firstWhereOrNull((s) => s.name == removedSubject.subjectName)
                ?.id ==
            id);
      }

      customExamQuestions.refresh();
      log("Removed subject at index $subjectIndex. Remaining: ${customExamQuestions.value?.subjects?.length}");
    }
  }

  void removeTopic(int subjectIndex, int topicIndex) {
    if (customExamQuestions.value?.subjects != null &&
        subjectIndex < customExamQuestions.value!.subjects!.length &&
        topicIndex <
            customExamQuestions.value!.subjects![subjectIndex].topics!.length) {
      final removedTopic = customExamQuestions
          .value!.subjects![subjectIndex].topics!
          .removeAt(topicIndex);

      // Remove the topic from the selected list
      if (removedTopic['topicName'] != null) {
        selectedTopics[subjectIndex]?.remove(removedTopic['topicName']);
      }

      customExamQuestions.refresh();
      log("Removed topic at index $topicIndex from subject at index $subjectIndex.");
    }
  }

String getFormattedExamName() {
  final now = DateTime.now();

  // Day with suffix (1st, 2nd, 3rd, 4th...)
  String getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  final day = getDayWithSuffix(now.day);
  final month = DateFormat('MMM').format(now); // Jan, Feb, etc.
  final year = now.year;
  final time = DateFormat('hh_mm_a').format(now); // 12_00_PM

  return '${day}_${month}_$year\_$time';
}
  void generateCustomExam() {
    if (customExamQuestions.value == null ||
        customExamQuestions.value!.subjects == null ||
        customExamQuestions.value!.subjects!.isEmpty) {
      log("No subjects available to generate a custom exam.");
      Utils.showSnackbar(message: "No subjects selected for custom exam", isSuccess: false);
      return;
    }
    
    // Check if any subjects have topics
    bool hasTopics = false;
    for (var subject in customExamQuestions.value!.subjects!) {
      if (subject.topics != null && subject.topics!.isNotEmpty) {
        hasTopics = true;
        break;
      }
    }
    
    if (!hasTopics) {
      Utils.showSnackbar(message: "Please add at least one topic to create an exam", isSuccess: false);
      return;
    }
    
    // Check if any topic has more questions requested than available
    bool hasExceededCounts = false;
    String exceededTopicName = "";
    
    for (var subject in customExamQuestions.value!.subjects!) {      for (var topic in subject.topics ?? []) {
        final topicId = topic['topic']?.toString();
        if (topicId == null || topicId.isEmpty) {
          continue;
        }
        
        final requestedCount = (topic['questionCount'] ?? 0) as int;
        
        if (!isQuestionCountAvailable(topicId, requestedCount)) {
          hasExceededCounts = true;
          exceededTopicName = topic['topicName'] ?? 'Unknown';
          break;
        }
      }
      if (hasExceededCounts) break;
    }
    
    if (hasExceededCounts) {
      Utils.showSnackbar(
        message: "Topic '$exceededTopicName' has more questions requested than available. Please reduce the count.",
        isSuccess: false
      );
      return;
    }

    // Build the selectedTopics payload first, as this is the most critical part
    final selectedTopics = buildSelectedTopicsPayload();
    if (selectedTopics.isEmpty) {
      return; // Error already shown by buildSelectedTopicsPayload
    }    // Calculate total questions count
    final int totalQuestions = customExamQuestions.value!.subjects?.fold<int>(0, (sum, subject) {
      return sum +
          (subject.topics?.fold<int>(0, (topicSum, topic) {
                return topicSum +
                    ((topic['questionCount'] ?? 0) as num).toInt();
              }) ??
              0);
    }) ?? 0;

    // Ensure we have at least one question
    if (totalQuestions <= 0) {
      Utils.showSnackbar(
        message: "Please select at least one question to create an exam",
        isSuccess: false
      );
      return;
    }    // Calculate start and end times
    final DateTime startTime = DateTime.now();
    // Give users more reasonable time: 2 minutes per question (minimum 30 minutes)
    final int examDurationMinutes = (totalQuestions * 2).clamp(30, 300); // Min 30 mins, Max 5 hours
    final DateTime endTime = startTime.add(Duration(minutes: examDurationMinutes));
    
    log("Creating custom exam with $totalQuestions total questions");
    log("Start time: ${startTime.toIso8601String()}");
    log("End time: ${endTime.toIso8601String()}");
    log("Total duration: $examDurationMinutes minutes (${(examDurationMinutes/60).toStringAsFixed(1)} hours)");

    final payload = {
      "name": "Custom Exam ${getFormattedExamName()}", 
      "description": "This is a custom exam with $totalQuestions questions",
      "startCustomExam": startTime.toIso8601String(),
      "endCustomExam": endTime.toIso8601String(), // Current time + reasonable exam duration
      "totalMarks": totalQuestions, // Total marks equal to number of questions
      "totalQuestions": totalQuestions,
      "totalTime": examDurationMinutes, // Total time in minutes for the exam
      "marksPerQuestion": 1, // 1 mark per question
      "selectedTopics": selectedTopics,
    };
    log("Generated custom exam payload: $payload");
    final request = CustomExamRequestModel.fromJson(payload);
    _apiHelper.generateCustomExam(request).then((result) {
      result.fold(
        (error) {
          log('Error generating custom exam: ${error.message}');
          Utils.showSnackbar(message: error.message, isSuccess: false);
        },
        (response) {
          try {
            log('Response body: ${response.body}');
            if (response.body['success'] == true && response.body['data'] != null && response.body['data']['_id'] != null) {
              Utils.showSnackbar(
                  message: "Successfully generated custom exam", isSuccess: true);
              log('Successfully generated custom exam: ${response.body['data']['_id']}');
              Get.toNamed(Routes.customExamDetails, arguments: {
                "customExamId": response.body['data']['_id'],
              });
            } else {
              log('Invalid response format or missing _id: ${response.body}');
              Utils.showSnackbar(
                  message: "Error creating exam: Invalid response format", 
                  isSuccess: false);
            }
          } catch (e) {
            log('Error processing success response: $e');
            Utils.showSnackbar(
                message: "Error processing response", isSuccess: false);
          }
        },
      );
    });
  }

  List<Map<String, dynamic>> buildSelectedTopicsPayload() {
    if (customExamQuestions.value == null ||
        customExamQuestions.value!.subjects == null ||
        customExamQuestions.value!.subjects!.isEmpty) {
      return [];
    }
    
    List<Map<String, dynamic>> result = [];
    
    // Loop through each subject and topic to build the payload
    for (var subject in customExamQuestions.value!.subjects!) {
      if (subject.topics == null || subject.topics!.isEmpty) {
        continue;
      }
      
      for (var topic in subject.topics!) {
        // Check if topic ID exists and is not empty
        if (topic['topic'] == null || topic['topic'].toString().trim().isEmpty) {
          log("WARNING: Topic ID is null or empty for topic: ${topic['topicName']}");
          continue;
        }
        
        // Get topic ID and ensure it's a string
        String topicId = topic['topic'].toString().trim();
        
        // Get question count with default of 1
        int questionCount = (topic['questionCount'] ?? 1) as int;
        
        // Create topic using the Topic class
        Topic topicObj = Topic(
          id: topicId,
          name: topic['topicName']?.toString() ?? '',
          totalQuestions: questionCount
        );
        
        // Add the topic's JSON representation
        Map<String, dynamic> topicEntry = topicObj.toJson();
        log("Adding topic to payload: $topicEntry");
        result.add(topicEntry);
      }
    }
    
    if (result.isEmpty) {
      log("ERROR: No valid topics found for the custom exam!");
      Utils.showSnackbar(
        message: "Please add at least one valid topic with a question count",
        isSuccess: false
      );
      return [];
    }
    
    log("Final selectedTopics payload: $result");
    return result;
  }
}
