import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/APIs/custom_error.dart';
import 'package:prostuti/app/models/institution.dart';
import 'package:prostuti/app/models/institution_type.dart';
import 'package:prostuti/app/models/user_model.dart';
import 'package:prostuti/app/modules/ranking/models/ranking_info.dart';
import 'package:prostuti/app/routes/app_pages.dart';

import '../constant/app_config.dart';
import '../modules/contest-details/models/contest_details_model.dart';
import '../modules/contests/models/contest_model.dart';
import '../modules/custom-exam/models/custom_exam_request_model.dart';
import '../modules/custom-exam-details/models/custom_exam_response_model.dart';
import '../modules/exam-topics/models/exam_topics_model.dart';
import '../modules/exam-types/models/exam_type_model.dart';
import '../modules/job-circulars/models/job-circulars-model.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/model-tests-details/models/model_test_response_model.dart';
import '../modules/model-tests/models/model_test_model.dart';
import '../modules/questions/models/question_model.dart';
import '../modules/register/models/register_model.dart';
import '../modules/subjects/models/subjects_model.dart';
import '../storage/storage_helper.dart';
import 'api_helper.dart';

class ApiHelperImpl extends GetConnect implements ApiHelper {
  @override
  void onInit() {
    super.onInit(); // Ensure this is called to properly set up GetConnect.

    log("url: ${'${AppConfig.baseUrl}${AppConfig.apiVersion}/'}");
    httpClient.baseUrl = '${AppConfig.baseUrl}${AppConfig.apiVersion}/';
    httpClient.timeout = const Duration(seconds: AppConfig.timeoutDuration);
    log("ApiHelperImpl initialized with baseUrl: ${httpClient.baseUrl}");
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<Object?>((request) async {
      final token = await StorageHelper.getToken(); // Fetch token
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token'; // Add Bearer token
      } else {
        Get.toNamed(Routes.login);
      }
      log('Request: ${request.method} ${request.url}');
      log('Headers: ${request.headers}');
      log('Body: ${request.bodyBytes}');
      log('token: $token');
      return request;
    });

    httpClient.addResponseModifier<Object?>((request, response) {
      log('Response: ${response.statusCode}, Body: ${response.body}');
      return response;
    });
  }

  Future<Either<CustomError, T>> _convert<T>(
      Response response, T Function(Map<String, dynamic>) fromJson) async {
    if (response.statusCode == 200) {
      try {
        return Right(fromJson(response.body));
      } catch (e) {
        return Left(
            CustomError(response.statusCode, message: 'Parsing error: $e'));
      }
    } else {
      return Left(
          CustomError(response.statusCode, message: '${response.statusText}'));
    }
  }

  @override
  Future<Either<CustomError, Response<dynamic>>> register(
      RegisterRequestModel register) async {
    final response = await post('users', register.toJson());
    // You can handle the response directly or transform it as needed.
    if (response.statusCode == 200) {
      return Right(response); // Return the raw response.
    } else {
      return Left(
          CustomError(response.statusCode, message: '${response.statusText}'));
    }
  }

  @override
  Future<Either<CustomError, LoginResponseModel>> login(
      LoginRequestModel payload) async {
    final response = await post('users/login', payload.toJson());

    if (response.statusCode == 200 && response.body['success'] == true) {
      try {
        return Right(LoginResponseModel.fromJson(response.body));
      } catch (e) {
        return Left(CustomError(
          response.statusCode,
          message: 'Parsing error: $e',
        ));
      }
    } else {
      return Left(CustomError(
        response.statusCode,
        message: response.body['message'] ?? 'Unknown error occurred',
      ));
    }
  }

  @override
  Future<Either<CustomError, Response>> forgotPassword(String email) async {
    try {
      final payload = {"email": email};
      final response = await post('users/forgot-password/', payload);
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to send reset code',
        ));
      }
    } catch (e) {
      log('Error in forgotPassword: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, Response>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final payload = {
        "email": email,
        "code": code,
        "newPassword": newPassword,
      };
      final response = await post('users/reset-password/', payload);
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to reset password',
        ));
      }
    } catch (e) {
      log('Error in resetPassword: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<ExamType>>> getExamTypes() async {
    final response = await get('exam-types');
    if (response.statusCode == 200) {
      try {
        List<ExamType> examTypes = (response.body['data'] as List)
            .map((item) => ExamType.fromJson(item))
            .toList();
        return Right(examTypes);
      } catch (e) {
        return Left(
            CustomError(response.statusCode, message: 'Parsing error: $e'));
      }
    } else {
      return Left(CustomError(response.statusCode,
          message: response.statusText ?? 'Error'));
    }
  }

  @override
  Future<Either<CustomError, List<Contest>>> fetchAllContests() async {
    try {
      final response = await get('contests');
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final contests = data.map((json) => Contest.fromJson(json)).toList();
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch contests'));
      }
    } catch (e) {
      log('Error fetching contests: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<ModelTest>>> fetchAllModelTests() async {
    try {
      final response = await get('models');
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        log("model dataaa: $data");
        final contests = data.map((json) => ModelTest.fromJson(json)).toList();
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch models'));
      }
    } catch (e) {
      log('Error fetching models: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Question>>> fetchAllQuestions() async {
    try {
      final response = await get('questions');
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final questions = data.map((json) => Question.fromJson(json)).toList();
        return Right(questions);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch questions'));
      }
    } catch (e) {
      log('Error fetching questions: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, Response>> verifyOtp(
      Map<String, dynamic> data) async {
    try {
      // Construct the payload as a Map
      final payload = data;

      // Make the POST request
      final Response response = await post('users/verify-otp', payload);

      // Handle response based on status code
      if (response.statusCode == 200) {
        return Right(response); // Successful response
      } else {
        return Left(
          CustomError(
            response.statusCode ?? 500,
            message: response.body['message'] ?? 'Error verifying OTP',
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, UserProfile>> getUserProfile(String userId) async {
    try {
      final response = await get('users/$userId');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final userData = response.body['data'] as Map<String, dynamic>;
        return Right(UserProfile.fromJson(userData));
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to fetch user profile'
        ));
      }
    } catch (error) {
      log('getUserProfile error: $error');
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }

  @override
  Future<Either<CustomError, UserProfile>> updateUserProfile(UserProfile profile) async {
    try {
      final data = profile.toJson();
      final response = await put('users/', data);
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final updatedData = response.body['data'] as Map<String, dynamic>;
        return Right(UserProfile.fromJson(updatedData));
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to update user profile'
        ));
      }
    } catch (error) {
      log('updateUserProfile error: $error');
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }

  @override
  Future<Either<CustomError, Response>> registerContest(
      String contestId) async {
    try {
      // Fetch the Bearer token from storage
      final token = await StorageHelper.getToken();

      // Ensure the token is not null
      if (token == null) {
        return Left(CustomError(401, message: 'Unauthorized: No token found'));
      }

      // Set up the payload
      final payload = {"contest": contestId};

      // Add Authorization header
      final headers = {
        'Authorization': 'Bearer $token',
      };

      // Make the POST request
      final response =
          await post('register-contests', payload, headers: headers);

      // Handle the response
      if (response.statusCode == 200) {
        return Right(response); // Successful response
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Error registering contest',
        ));
      }
    } catch (e) {
      // Handle exceptions
      log('Error registering contest: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Contest>>> fetchRecentContests(
      {String contestType = "recent"}) async {
    try {
      // Make the GET request to fetch recent contests
      final response = await get('contests/?contestType=$contestType');

      if (response.statusCode == 200 && response.body['success'] == true) {
        // Parse the response data into a list of Contest models
        final List<dynamic> data = response.body['data'];
        log('Raw API Response - Total contests: ${data.length}');
        // Log first contest for debugging
        if (data.isNotEmpty) {
          log('Sample contest data: ${data.first}');
        }
        final contests = data.map((json) => Contest.fromJson(json)).toList();
        return Right(contests); // Return the list of contests
      } else {
        // Handle API errors
        return Left(CustomError(
          response.statusCode,
          message:
              response.body['message'] ?? 'Failed to fetch recent contests',
        ));
      }
    } catch (e) {
      // Handle any network or parsing errors
      log('Error fetching recent contests: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  // @override
  // Future<Either<CustomError, ContestDetailsResponse>> fetchSingleContest(
  //     String contestId) async {
  //   try {
  //     // Make GET request
  //     final response = await get('contests/$contestId');

  //     if (response.statusCode == 200 && response.body['success'] == true) {
  //       // Parse the response into SingleContestResponse
  //       final data = ContestDetailsResponse.fromJson(response.body['data']);
  //       return Right(data);
  //     } else {
  //       // Handle API error
  //       return Left(CustomError(
  //         response.statusCode,
  //         message:
  //             response.body['message'] ?? 'Failed to fetch contest details',
  //       ));
  //     }
  //   } catch (e) {
  //     // Handle network or parsing errors
  //     log('Error fetching single contest: $e');
  //     return Left(CustomError(500, message: 'Network error: $e'));
  //   }
  // }

  @override
  Future<Either<CustomError, ContestDetailsResponse>> fetchSingleContest(
      String contestId) async {
    try {
      final response = await get('contests/$contestId');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final data = ContestDetailsResponse.fromJson(response.body['data']);
        return Right(data);
      } else {
        return Left(CustomError(
          response.statusCode,
          message:
              response.body['message'] ?? 'Failed to fetch contest details',
        ));
      }
    } catch (e) {
      log('Error fetching single contest: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, CustomExamDetailsResponse>> fetchSingleCustomExam(
      String customExamId) async {
    try {
      // Make GET request
      log('Request: get custom-exams/$customExamId');
      // log('token: ${_storageService.getToken()}');
      final response = await get('custom-exams/$customExamId');
      
      log('Response: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200 && response.body['success'] == true) {
        try {
          // Parse the response into CustomExamDetailsResponse
          final data = CustomExamDetailsResponse.fromJson(response.body['data']);
          return Right(data);
        } catch (parseError) {
          log('Error parsing custom exam response: $parseError');
          return Left(CustomError(
            500,
            message: 'Failed to parse custom exam details: $parseError',
          ));
        }
      } else {
        // Handle API error
        return Left(CustomError(
          response.statusCode,
          message:
              response.body['message'] ?? 'Failed to fetch custom exam details',
        ));
      }
    } catch (e) {
      // Handle network or parsing errors
      log('Error fetching single custom exam: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, ModelTestDetailsResponse>> fetchSingleModelTest(
      String modelTestId) async {
    try {
      // Make GET request
      final response = await get('models/$modelTestId');

      if (response.statusCode == 200 && response.body['success'] == true) {
        // Parse the response into SingleContestResponse
        final data = ModelTestDetailsResponse.fromJson(response.body['data']);
        return Right(data);
      } else {
        // Handle API error
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to fetch model details',
        ));
      }
    } catch (e) {
      // Handle network or parsing errors
      log('Error fetching model : $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<JobCircular>>> fetchJobCirculars() async {
    try {
      final response = await get('job-circulars');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final jobCirculars =
            data.map((json) => JobCircular.fromJson(json)).toList();
        return Right(jobCirculars);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to fetch job circulars',
        ));
      }
    } catch (e) {
      log('Error fetching job circulars: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Subjects>>> fetchSubjects() async {
    try {
      final response = await get('subjects');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final categories = data.map((json) => Subjects.fromJson(json)).toList();
        return Right(categories);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to fetch categories',
        ));
      }
    } catch (e) {
      log('Error fetching categories: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<SubjectTopics>>>
      fetchSubCategoriesByCategoryId(String categoryId) async {
    try {
      final response = await get('topics/all-topics-by-id/$categoryId');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final subCategories =
            data.map((json) => SubjectTopics.fromJson(json)).toList();
        return Right(subCategories);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to fetch subcategories',
        ));
      }
    } catch (e) {
      log('Error fetching subcategories: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, ContestData>> getLeaderboardRanks({
    required String contestId,
    String? division,
    String? district,
    String? upazila,
    String? institutionType,
  }) async {
    try {
      // Build a map of only the non-null params
      final queryParams = <String, String>{
        'contestId': contestId,
        if (division != null) 'division': division,
        if (district != null) 'district': district,
        if (upazila != null) 'upazila': upazila,
        if (institutionType != null) 'institutionType': institutionType,
      };

      // Turn them into a query string
      final qs = Uri(queryParameters: queryParams).query;
      final response = await get('leaderboard?$qs');
      inspect(response);

      if (response.statusCode == 200 && !response.hasError) {
        final Map<String, dynamic> data = response.body['data'];
        final rankingData = ContestData.fromJson(data);
        return Right(rankingData);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to fetch leaderboard',
        ));
      }
    } catch (e) {
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<InstitutionType>>> getInstitutionTypes() async {
    try {
      final response = await get('institution-types/');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        final List<InstitutionType> institutionTypes = 
            data.map((item) => InstitutionType.fromJson(item as Map<String, dynamic>)).toList();
        
        return Right(institutionTypes);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to fetch institution types'
        ));
      }
    } catch (error) {
      log('getInstitutionTypes error: $error');
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }

  @override
  Future<Either<CustomError, List<Institution>>> getInstitutions({String? institutionTypeId}) async {
    try {
      // Construct URL with query parameter if provided
      final String url = institutionTypeId != null 
          ? 'institutions?institutionType=$institutionTypeId' 
          : 'institutions';
      
      final response = await get(url);

      if (response.statusCode == 200 && !response.hasError) {
        final List<dynamic> dataList = response.body['data'] as List<dynamic>;

        final List<Institution> institutions = dataList
            .map((json) => Institution.fromJson(json as Map<String, dynamic>))
            .toList();

        return Right(institutions);
      } else {
        final message =
            response.body['message'] ?? 'Failed to fetch institutions';
        return Left(CustomError(response.statusCode, message: message));
      }
    } catch (e, st) {
      log('Error fetching institutions: $e\n$st');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, Response>> submitContestAnswer({
    required String questionId,
    required String contestId,
    required String selectedAnswer,
  }) async {
    try {
      // Prepare the payload
      final payload = {
        "question": questionId,
        "contest": contestId,
        "selectedAnswer": selectedAnswer,
      };
      log("payload $payload");
      // Fetch the Bearer token from storage
      final token = await StorageHelper.getToken();

      // Ensure token exists before making request
      if (token == null) {
        return Left(CustomError(401, message: 'Unauthorized: No token found'));
      }

      // Set headers
      final headers = {
        'Authorization': 'Bearer $token',
      };

      // Make the POST request
      final response = await post('attendees', payload, headers: headers);

      // Log for debugging
      log('Submit Contest Answer Response: ${response.statusCode}, Body: ${response.body}');

      // Handle response
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response); // Successful response
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Failed to submit answer',
        ));
      }
    } catch (e) {
      log('Error submitting contest answer: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, Response>> submitContest(String contestId) async {
    try {
      final token = await StorageHelper.getToken();

      if (token == null) {
        return Left(CustomError(401, message: 'Unauthorized: No token found'));
      }

      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response =
          await get('contests/submit-contest/$contestId', headers: headers);

      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response);
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Failed to submit contest',
        ));
      }
    } catch (e) {
      log('Error submitting contest: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, Response>> generateCustomExam(
      CustomExamRequestModel payload) async {
    try {
      final response = await post('custom-exams/generate-contest', payload.toJson());
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to generate custom exam'));
      }
    } catch (e) {
      log('Error generating custom exam: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, int>> fetchQuestionCountByTopicId(String topicId) async {
    try {
      final response = await get('questions/topics/num-of-question/$topicId');
      log('Response for topic count: ${response.body}');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        // The API returns count in the 'count' field, not 'data'
        final count = response.body['count'] as int? ?? 0;
        return Right(count);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch question count'));
      }
    } catch (e) {
      log('Error fetching question count: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Map<String, dynamic>>>> fetchCustomExams({
    int page = 1,
    int limit = 10
  }) async {
    try {
      final response = await get('custom-exams/?page=$page&limit=$limit');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        final List<Map<String, dynamic>> customExams = 
            data.map((item) => item as Map<String, dynamic>).toList();
        
        return Right(customExams);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to fetch custom exams'
        ));
      }
    } catch (error) {
      log('fetchCustomExams error: $error');
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }
}
