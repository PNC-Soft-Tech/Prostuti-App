import 'dart:developer';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../exam-topics/models/exam_topics_model.dart';
import '../models/custom_exam_model.dart';
import '../models/custom_exam_subject_model.dart';
import '../../subjects/models/subjects_model.dart';

class CustomExamController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var isLoading = false.obs;
  RxList<Subjects> subjects = <Subjects>[].obs;
  RxList<SubjectTopics> topics = <SubjectTopics>[].obs;

  // Reactive custom exam model
  Rxn<CustomExamModel> customExamQuestions = Rxn<CustomExamModel>();

  @override
  void onInit() {
    super.onInit();
    fetchSubjects(); // Fetch subjects on controller initialization

    // Initialize the custom exam data with a default subject and topic
    customExamQuestions.value = CustomExamModel(
      id: 'exam-1',
      subjects: [
        CustomExamSubject(
          id: 'subject-1',
          subjectName: null, // Initially null
          topics: [
            {
              'topicName': null, // Initially null
              'questionCount': null, // Initially null
            }
          ],
        ),
      ],
    );
  }

  Future<void> fetchSubjects() async {
    isLoading.value = true;
    final result = await _apiHelper.fetchSubjects();
    result.fold(
      (error) {
        log('Error fetching subjects: ${error.message}');
      },
      (data) {
        subjects.value = data;
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
        topics.clear(); // Clear stale data
      },
      (data) {
        // Deduplicate topics based on name
        topics.value = data
            .fold<Map<String, SubjectTopics>>({}, (map, topic) {
              map[topic.name] = topic; // Use name as unique key
              return map;
            })
            .values
            .toList();

        log('Fetched ${topics.length} unique topics for subject $subjectId');
      },
    );
  }

  void addSubject() {
    customExamQuestions.value ??= CustomExamModel(id: 'exam-1', subjects: []);
    customExamQuestions.value!.subjects?.add(
      CustomExamSubject(
        id: 'subject-${customExamQuestions.value!.subjects!.length + 1}',
        subjectName: null, // Initially null
        topics: topics.isNotEmpty
            ? [
                {
                  'topicName':
                      topics.first.name, // Default to first topic if available
                  'questionCount': 1, // Default question count
                }
              ]
            : [], // No topics if topics list is empty
      ),
    );

    customExamQuestions.refresh();
    log("Added a new subject. Total: ${customExamQuestions.value?.subjects?.length}");
  }

  void addTopic(int subjectIndex, String topicName, int questionCount) {
    if (customExamQuestions.value?.subjects != null &&
        subjectIndex < customExamQuestions.value!.subjects!.length) {
      CustomExamSubject subject =
          customExamQuestions.value!.subjects![subjectIndex];

      subject.topics ??= [];
      subject.topics!.add({
        'topicName': topicName,
        'questionCount': questionCount,
      });

      customExamQuestions.refresh();
      log("Added topic '$topicName' with $questionCount questions to subject at index $subjectIndex.");
    }
  }

  void removeSubject(int subjectIndex) {
    if (customExamQuestions.value?.subjects != null &&
        subjectIndex < customExamQuestions.value!.subjects!.length) {
      customExamQuestions.value!.subjects!.removeAt(subjectIndex);
      customExamQuestions.refresh();
      log("Removed subject at index $subjectIndex. Remaining: ${customExamQuestions.value?.subjects?.length}");
    }
  }

  void removeTopic(int subjectIndex, int topicIndex) {
    if (customExamQuestions.value?.subjects != null &&
        subjectIndex < customExamQuestions.value!.subjects!.length &&
        topicIndex <
            customExamQuestions.value!.subjects![subjectIndex].topics!.length) {
      customExamQuestions.value!.subjects![subjectIndex].topics!
          .removeAt(topicIndex);
      customExamQuestions.refresh();
      log("Removed topic at index $topicIndex from subject at index $subjectIndex.");
    }
  }
}
