import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../routes/app_pages.dart';
import '../../exam-topics/models/exam_topics_model.dart';
import '../models/custom_exam_model.dart';
import '../models/custom_exam_request_model.dart';
import '../models/custom_exam_subject_model.dart';
import '../../subjects/models/subjects_model.dart';

class CustomExamController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

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
            subjects: [
              CustomExamSubject(
                id: firstSubject.id, // Use API-provided ID
                subjectName: firstSubject.name ?? "", // Ensure not null
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
    final result = await _apiHelper.fetchSubCategoriesByCategoryId(subjectId);
    result.fold(
      (error) {
        log('Error fetching topics: ${error.message}');
        subjectTopicsMap[subjectId] = []; // Empty list for failed fetch
      },
      (data) {
        subjectTopicsMap[subjectId] = data; // Store topics for this subject
        log('Fetched ${data.length} topics for subject $subjectId');
        log('Fetched ${data.length} topics for subject length ${subjectTopicsMap[subjectId]?.length} - $selectedSubjectId');
        
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
      customExamQuestions.value!.subjects?.add(
        CustomExamSubject(
          id: selectedSubject.id, // Use the API-provided id
          subjectName: selectedSubject.name ?? "Unnamed Subject", // Default value to avoid null
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
        if (selectedTopic.id != null && selectedTopic.id.isNotEmpty) {
          fetchQuestionCountForTopic(selectedTopic.id);
        }
        
        // Store both topic id and topic name for reference.
        subject.topics!.add({
          'topic': selectedTopic.id, // Use topic id
          'topicName': selectedTopic.name ?? '', // Ensure no null value
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
    if (topicId == null || topicId.isEmpty) {
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
    
    // Check if any topic has more questions requested than available
    bool hasExceededCounts = false;
    String exceededTopicName = "";
    
    for (var subject in customExamQuestions.value!.subjects!) {
      for (var topic in subject.topics ?? []) {
        final topicId = topic['topic'];
        final requestedCount = (topic['questionCount'] ?? 0) as int;
        
        if (!isQuestionCountAvailable(topicId, requestedCount)) {
          hasExceededCounts = true;
          exceededTopicName = topic['topicName'];
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

    final payload = {
      "name": "Custom Exam ${getFormattedExamName()}", 
      //use current date fiormat DD_MM_YYYY
      
      "description": "This is a custom exam",
      "startCustomExam": DateTime.now().toIso8601String(),
      "endCustomExam":
          DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      "totalMarks":
          customExamQuestions.value!.subjects?.fold<int>(0, (sum, subject) {
        return sum +
            (subject.topics?.fold<int>(0, (topicSum, topic) {
                  return topicSum +
                      ((topic['questionCount'] ?? 0) as num).toInt();
                }) ??
                0);
      }),
      "totalQuestions":
          customExamQuestions.value!.subjects?.fold<int>(0, (sum, subject) {
        return sum +
            (subject.topics?.fold<int>(0, (topicSum, topic) {
                  return topicSum +
                      ((topic['questionCount'] ?? 0) as num).toInt();
                }) ??
                0);
      }),
      "totalTime":
          customExamQuestions.value!.subjects?.fold<int>(0, (sum, subject) {
        return sum +
            (subject.topics?.fold<int>(0, (topicSum, topic) {
                  return topicSum +
                      ((topic['questionCount'] ?? 0) as num).toInt();
                }) ??
                0);
      }),
      // Map each topic to use its id ("topic" key) instead of topic name.
      "selectedTopics": customExamQuestions.value!.subjects
          ?.expand((subject) =>
              subject.topics
                  ?.where((topic) =>
                      topic['topic'] != null &&
                      topic['topic'].toString().trim().isNotEmpty)
                  .map((topic) => {
                        "topic": topic['topic'],
                        "totalQuestions": topic['questionCount'] ?? 0,
                      }) ??
              [])
          .toList(),
      // "id": customExamQuestions.value!.id,
      // "subjects": customExamQuestions.value!.subjects?.map((subject) => {
      //       "id": subject.id,
      //       "subjectName": subject.subjectName,
      //       "topics": subject.topics,
      //     }).toList(),
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
          Utils.showSnackbar(
              message: "Successfully generated custom exam", isSuccess: true);
          log('Successfully generated custom exam: ${response.body['data']['_id']}');
          Get.toNamed(Routes.customExamDetails, arguments: {
            "customExamId": response.body['data']['_id'],
          });
        },
      );
    });
  }
}
