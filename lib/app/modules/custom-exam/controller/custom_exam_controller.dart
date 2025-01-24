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
  RxList<String> selectedSubjects = <String>[].obs;
  RxString selectedSubjectId = ''.obs;
  RxMap<int, List<String>> selectedTopics = <int, List<String>>{}
      .obs; // Map to track selected topics for each subject

  // Reactive custom exam model
  Rxn<CustomExamModel> customExamQuestions = Rxn<CustomExamModel>();
  RxMap<String, List<SubjectTopics>> subjectTopicsMap =
      <String, List<SubjectTopics>>{}.obs;

  @override
  void onInit() {
    super.onInit();

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
                subjectName: firstSubject.name, // Name of the first subject
                // topics: subjectTopicsMap[firstSubject.id]?.isNotEmpty ?? false
                //     ? [
                //         {
                //           'topicName':
                //               subjectTopicsMap[firstSubject.id]!.first.name,
                //           'questionCount': 1, // Default question count
                //         }
                //       ]
                //     : [], // No topics if the first subject has none
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
          subjectName: selectedSubject.name,
          // topics: subjectTopicsMap[selectedSubject.id]?.isNotEmpty ?? false
          //     ? [
          //         {
          //           'topicName':
          //               subjectTopicsMap[selectedSubject.id]!.first.name,
          //           'questionCount': 1, // Default question count
          //         }
          //       ]
          //     : [], // No topics if the subject's topics list is empty
        ),
      );

      customExamQuestions.refresh();
      log("Added a new subject. Total: ${customExamQuestions.value?.subjects?.length}");
    } else {
      log("No subjects available to add.");
    }
  }

  void addTopic(int subjectIndex) {
    if (customExamQuestions.value?.subjects != null &&
        subjectIndex < customExamQuestions.value!.subjects!.length) {
      CustomExamSubject subject =
          customExamQuestions.value!.subjects![subjectIndex];

      final availableTopics = subjectTopicsMap[subject.id]?.where((topic) {
        final isAlreadySelected =
            subject.topics?.any((t) => t['topicName'] == topic.name) ?? false;
        log("Topic ${topic.name} isAlreadySelected: $isAlreadySelected");
        return !isAlreadySelected;
      }).toList();

      log("Available topics for subject ${subject.id}: ${availableTopics?.map((e) => e.name).toList()}");

      // Ensure topics exist for the subject
      if (availableTopics != null && availableTopics.isNotEmpty) {
        // Add the first available topic
        subject.topics ??= [];
        subject.topics!.add({
          'topicName': availableTopics.first.name, // Fetch topic name from API
          'questionCount': 1, // Default question count
        });

        customExamQuestions.refresh();
        log("Added topic '${availableTopics.first.name}' with 1 question to subject at index $subjectIndex.");
      } else {
        log("No available topics to add for subject at index $subjectIndex.");
      }
    }
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
}
