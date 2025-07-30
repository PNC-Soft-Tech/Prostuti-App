import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/models/institution.dart';
import 'package:prostuti/app/models/institution_type.dart';
import 'package:prostuti/app/models/user_model.dart';
import 'package:prostuti/app/modules/exam-topics/models/exam_topics_model.dart';
import 'package:prostuti/app/modules/ranking/models/ranking_info.dart';

import '../modules/contest-details/models/contest_details_model.dart';
import '../modules/contests/models/contest_model.dart';
import '../modules/custom-exam/models/custom_exam_request_model.dart';
import '../modules/custom-exam-details/models/custom_exam_response_model.dart';
import '../modules/exam-types/models/exam_type_model.dart';
import '../modules/job-circulars/models/job-circulars-model.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/model-tests-details/models/model_test_response_model.dart';
import '../modules/model-tests/models/model_test_model.dart';
import '../modules/questions/models/question_model.dart';
import '../modules/register/models/register_model.dart';
import '../modules/subjects/models/subjects_model.dart';
import 'custom_error.dart';

abstract class ApiHelper {
  // Future<Either<CustomError, LoginResponse>> login(LoginRequestModel login);
  Future<Either<CustomError, LoginResponseModel>> login(
      LoginRequestModel payload);

  Future<Either<CustomError, Response>> register(RegisterRequestModel register);

  // Forgot Password & Reset Password APIs
  Future<Either<CustomError, Response>> forgotPassword(String email);
  Future<Either<CustomError, Response>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  // Future<Either<CustomError, List<JobCircular>>> fetchJobCirculars();
  // Future<Either<CustomError, List<JobCategory>>> getJobCategories();
  Future<Either<CustomError, List<ExamType>>> getExamTypes();
  Future<Either<CustomError, List<Contest>>> fetchAllContests();
  Future<Either<CustomError, List<Contest>>> fetchContestHistory();
  Future<Either<CustomError, List<Question>>> fetchAllQuestions();
  Future<Either<CustomError, List<ModelTest>>> fetchAllModelTests();
// Future<Either<CustomError, SingleContest>> fetchSingleContest(String contestId);
  Future<Either<CustomError, Response>> verifyOtp(Map<String, dynamic> data);
  Future<Either<CustomError, UserProfile>> getUserProfile(String userId);
  Future<Either<CustomError, UserProfile>> updateUserProfile(
      UserProfile profile);
  Future<Either<CustomError, Response>> registerContest(String contestId);
  Future<Either<CustomError, List<Contest>>> fetchRecentContests();
  Future<Either<CustomError, ContestDetailsResponse>> fetchSingleContest(
      String contestId);
  Future<Either<CustomError, CustomExamDetailsResponse>> fetchSingleCustomExam(
      String customExamId);
  Future<Either<CustomError, ModelTestDetailsResponse>> fetchSingleModelTest(
      String modelTestId);
  Future<Either<CustomError, List<JobCircular>>> fetchJobCirculars();
  Future<Either<CustomError, List<Subjects>>> fetchSubjects();
  Future<Either<CustomError, List<SubjectTopics>>>
      fetchSubCategoriesByCategoryId(String categoryId);

  Future<Either<CustomError, ContestData>> getLeaderboardRanks({
    required String contestId,
    String? division,
    String? district,
    String? upazila,
    String? institutionType,
  });

  Future<Either<CustomError, List<InstitutionType>>> getInstitutionTypes();
  Future<Either<CustomError, List<Institution>>> getInstitutions(
      {String? institutionTypeId});

  Future<Either<CustomError, Response>> submitContestAnswer({
    required String questionId,
    required String contestId,
    required String selectedAnswer,
  });
  Future<Either<CustomError, Response>> submitContest(String contestId);
  Future<Either<CustomError, Response>> generateCustomExam(
      CustomExamRequestModel payload);

  // New method to fetch question count by topic ID
  Future<Either<CustomError, int>> fetchQuestionCountByTopicId(String topicId);

  // New method to fetch custom exams with pagination
  Future<Either<CustomError, List<Map<String, dynamic>>>> fetchCustomExams(
      {int page = 1, int limit = 10});

  // Corner-specific filtered API methods
  Future<Either<CustomError, List<Contest>>> fetchFilteredContests(String contestType);
  Future<Either<CustomError, List<ModelTest>>> fetchFilteredModelTests(String modelType);
  Future<Either<CustomError, List<Map<String, dynamic>>>> fetchFilteredCustomExams({
    required String customExamTypeFilter,
    int page = 1,
    int limit = 10,
  });

  // ExamType-based filtered API methods
  Future<Either<CustomError, List<Contest>>> fetchContestsByExamType(String examType);
  Future<Either<CustomError, List<ModelTest>>> fetchModelTestsByExamType(String examType);
  Future<Either<CustomError, List<Map<String, dynamic>>>> fetchCustomExamsByExamType({
    required String examType,
    int page = 1,
    int limit = 10,
  });
}
