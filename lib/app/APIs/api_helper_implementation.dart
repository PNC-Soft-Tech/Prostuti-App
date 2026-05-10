import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/APIs/custom_error.dart';
import 'package:prostuti/app/models/institution.dart';
import 'package:prostuti/app/models/institution_type.dart';
import 'package:prostuti/app/models/user_model.dart';
import 'package:prostuti/app/modules/ranking/models/ranking_info.dart';

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
      final token = await StorageHelper.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      // Don't redirect to /login when token is missing — public endpoints
      // (register, login, forgot-password, OTP verify) legitimately have no
      // token. Protected endpoints that hit a 401 are handled by their
      // controllers or by AuthService.checkFeatureAccess.
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

  /// Safely pull a `message` string out of a Response body. When the network
  /// call fails at the transport layer (timeout, DNS, TLS, connection reset,
  /// cold-start hang) GetConnect returns a Response with a `null` body — and
  /// the common pattern `response.body['message'] ?? fallback` crashes because
  /// `[]` runs on null before `??` can fire. Always go through this helper.
  String _safeMsg(Response response, String fallback) {
    final body = response.body;
    if (body is Map) {
      final m = body['message'];
      if (m is String && m.isNotEmpty) return m;
    }
    return fallback;
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

    if (response.statusCode == 200) {
      return Right(response);
    } else {
      return Left(CustomError(response.statusCode,
          message: _safeMsg(response, 'Registration failed')));
    }
  }

  @override
  Future<Either<CustomError, LoginResponseModel>> login(
      LoginRequestModel payload) async {
    final response = await post('users/login', payload.toJson());
    final body = response.body;

    if (response.statusCode == 200 && body is Map && body['success'] == true) {
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
        message: _safeMsg(response, 'Unknown error occurred'),
      ));
    }
  }

  @override
  Future<Either<CustomError, Response>> forgotPassword(String email) async {
    try {
      final payload = {"email": email};
      final response = await post('users/forgot-password/', payload);
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        return Right(response);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to send reset code'),
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
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        return Right(response);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to reset password'),
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
      final body = response.body;
      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final List<dynamic> data = (body['data'] as List?) ?? [];
        final contests = data.map((json) => Contest.fromJson(json)).toList();
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to fetch contests')));
      }
    } catch (e) {
      log('Error fetching contests: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Contest>>> fetchContestHistory() async {
    try {
      final response = await get('contest-points/history');
      final body = response.body;
      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final List<dynamic> data = (body['data'] as List?) ?? [];
        final contests =
            data.map((json) => Contest.fromJson(json['contest'])).toList();
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to fetch contests history')));
      }
    } catch (e) {
      log('Error fetching contests history: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<ModelTest>>> fetchAllModelTests() async {
    try {
      final response = await get('models');
      final body = response.body;
      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final List<dynamic> data = (body['data'] as List?) ?? [];
        final contests = data.map((json) => ModelTest.fromJson(json)).toList();
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to fetch models')));
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
      final body = response.body;
      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final List<dynamic> data = (body['data'] as List?) ?? [];
        final questions = data.map((json) => Question.fromJson(json)).toList();
        return Right(questions);
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to fetch questions')));
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
            message: _safeMsg(response, 'Error verifying OTP'),
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
    print(
        "DEBUG: ApiHelper.getUserProfile - Fetching profile for userId: $userId");
    try {
      final response = await get('users/$userId');

      print(
          "DEBUG: ApiHelper.getUserProfile - Response received, status: ${response.statusCode}");
      print("DEBUG: ApiHelper.getUserProfile - Raw response: ${response.body}");

      if (response.statusCode == 200 && response.body['success'] == true) {
        final rawData = response.body['data'];

        // Log the raw profile data
        print(
            "DEBUG: ApiHelper.getUserProfile - Response contains success=true and data");
        print(
            "DEBUG: ApiHelper.getUserProfile - Raw data type: ${rawData.runtimeType}");

        // Log specific fields we care about
        if (rawData is Map) {
          print(
              "DEBUG: ApiHelper.getUserProfile - Raw profilePic: '${rawData['profilePic']}'");

          // Check if profilePic is a valid URL format
          final picValue = rawData['profilePic'];
          if (picValue != null) {
            _validateAndLogProfileImageUrl(picValue.toString(), "API response");
          } else {
            print(
                "WARNING: ApiHelper.getUserProfile - No profilePic value in the API response");
          }
        }

        // The data should already be a Map from the API response
        if (rawData is Map<String, dynamic>) {
          try {
            print(
                "DEBUG: ApiHelper.getUserProfile - Creating UserProfile from raw data");
            final userProfile = UserProfile.fromJson(rawData);
            print(
                "DEBUG: ApiHelper.getUserProfile - Parsed profilePic: '${userProfile.profilePic}'");

            // Validate the parsed profilePic URL
            _validateAndLogProfileImageUrl(
                userProfile.profilePic, "parsed UserProfile");

            return Right(userProfile);
          } catch (parseError) {
            print("ERROR: ApiHelper.getUserProfile - Parse error: $parseError");
            return Left(CustomError(500,
                message: 'Failed to parse user profile: $parseError'));
          }
        } else {
          print(
              "ERROR: ApiHelper.getUserProfile - Unexpected data type: ${rawData.runtimeType}");
          return Left(CustomError(500, message: 'Invalid user data format'));
        }
      } else {
        print(
            "ERROR: ApiHelper.getUserProfile - Error response: ${response.body}");
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to fetch user profile')));
      }
    } catch (error) {
      print("ERROR: ApiHelper.getUserProfile - Exception caught: $error");
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }

  @override
  Future<Either<CustomError, UserProfile>> updateUserProfile(
      UserProfile profile) async {
    try {
      // Prepare the data for the API - ensure we're sending proper IDs for institution objects
      final data = profile.toJson();

      // Validate profile image URL before sending to API
      _validateAndLogProfileImageUrl(
          profile.profilePic, "updateUserProfile request");

      // For API compatibility, ensure we're sending string IDs, not full objects
      if (profile.institutionObj != null) {
        data['institution'] = profile.institutionObj!.id;
      }
      if (profile.institutionTypeObj != null) {
        data['institutionType'] = profile.institutionTypeObj!.id;
      }

      final response = await put('users/', data);
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final updatedData = body['data'] as Map<String, dynamic>;
        try {
          final userProfile = UserProfile.fromJson(updatedData);

          // Validate the profile image URL in the response
          print("DEBUG: updateUserProfile - Profile updated successfully");
          _validateAndLogProfileImageUrl(
              userProfile.profilePic, "updateUserProfile response");

          return Right(userProfile);
        } catch (parseError) {
          log('Error parsing updated user profile: $parseError');
          return Left(CustomError(500,
              message: 'Failed to parse updated user profile: $parseError'));
        }
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to update user profile')));
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
          message: _safeMsg(response, 'Error registering contest'),
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
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        // Parse the response data into a list of Contest models
        final List<dynamic> data = (body['data'] as List?) ?? [];
        log('Raw API Response - Total contests: ${data.length}');
        if (data.isNotEmpty) {
          log('Sample contest data: ${data.first}');
        }
        final contests = data.map((json) => Contest.fromJson(json)).toList();
        return Right(contests);
      } else {
        // Handle API errors
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to fetch recent contests'),
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
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final data = ContestDetailsResponse.fromJson(body['data']);
        return Right(data);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to fetch contest details'),
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
      log('Request: get custom-exams/$customExamId');
      final response = await get('custom-exams/$customExamId');
      final body = response.body;

      log('Response: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        try {
          final data = CustomExamDetailsResponse.fromJson(body['data']);
          return Right(data);
        } catch (parseError) {
          log('Error parsing custom exam response: $parseError');
          return Left(CustomError(
            500,
            message: 'Failed to parse custom exam details: $parseError',
          ));
        }
      } else {
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to fetch custom exam details'),
        ));
      }
    } catch (e) {
      log('Error fetching single custom exam: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, ModelTestDetailsResponse>> fetchSingleModelTest(
      String modelTestId) async {
    try {
      final response = await get('models/$modelTestId');
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final data = ModelTestDetailsResponse.fromJson(body['data']);
        return Right(data);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to fetch model details'),
        ));
      }
    } catch (e) {
      log('Error fetching model : $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<JobCircular>>> fetchJobCirculars() async {
    try {
      final response = await get('job-circulars');
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final List<dynamic> data = (body['data'] as List?) ?? [];
        final jobCirculars =
            data.map((json) => JobCircular.fromJson(json)).toList();
        return Right(jobCirculars);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to fetch job circulars'),
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
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final List<dynamic> data = (body['data'] as List?) ?? [];
        final categories = data.map((json) => Subjects.fromJson(json)).toList();
        return Right(categories);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to fetch categories'),
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
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final List<dynamic> data = (body['data'] as List?) ?? [];
        final subCategories =
            data.map((json) => SubjectTopics.fromJson(json)).toList();
        return Right(subCategories);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to fetch subcategories'),
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

      final body = response.body;
      if (response.statusCode == 200 &&
          !response.hasError &&
          body is Map &&
          body['data'] is Map<String, dynamic>) {
        final Map<String, dynamic> data = body['data'] as Map<String, dynamic>;
        final rankingData = ContestData.fromJson(data);
        return Right(rankingData);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: _safeMsg(response, 'Failed to fetch leaderboard'),
        ));
      }
    } catch (e) {
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<InstitutionType>>>
      getInstitutionTypes() async {
    try {
      final response = await get('institution-types/');
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final List<dynamic> data = (body['data'] as List?) ?? [];
        final List<InstitutionType> institutionTypes = data
            .map((item) =>
                InstitutionType.fromJson(item as Map<String, dynamic>))
            .toList();

        return Right(institutionTypes);
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to fetch institution types')));
      }
    } catch (error) {
      log('getInstitutionTypes error: $error');
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }

  @override
  Future<Either<CustomError, List<Institution>>> getInstitutions(
      {String? institutionTypeId}) async {
    try {
      // Construct URL with query parameter if provided
      final String url = institutionTypeId != null
          ? 'institutions?institutionType=$institutionTypeId'
          : 'institutions';

      final response = await get(url);
      final body = response.body;

      if (response.statusCode == 200 && !response.hasError && body is Map) {
        final List<dynamic> dataList = (body['data'] as List?) ?? [];

        final List<Institution> institutions = dataList
            .map((json) => Institution.fromJson(json as Map<String, dynamic>))
            .toList();

        return Right(institutions);
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to fetch institutions')));
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
      // Server schema validates `selectedAnswers` (plural) as an array of
      // option keys — supports multi-answer questions, but also the common
      // single-answer case via a 1-element list. The client API still takes a
      // single string; we wrap it here so every caller stays simple.
      final payload = {
        "question": questionId,
        "contest": contestId,
        "selectedAnswers":
            selectedAnswer.isEmpty ? <String>[] : <String>[selectedAnswer],
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
      final body = response.body;
      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        return Right(response); // Successful response
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: _safeMsg(response, 'Failed to submit answer'),
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
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        return Right(response);
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: _safeMsg(response, 'Failed to submit contest'),
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
      final response =
          await post('custom-exams/generate-contest', payload.toJson());
      final body = response.body;
      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        return Right(response);
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to generate custom exam')));
      }
    } catch (e) {
      log('Error generating custom exam: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, int>> fetchQuestionCountByTopicId(
      String topicId) async {
    try {
      final response = await get('questions/topics/num-of-question/$topicId');
      log('Response for topic count: ${response.body}');
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        // The API returns count in the 'count' field, not 'data'
        final count = body['count'] as int? ?? 0;
        return Right(count);
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to fetch question count')));
      }
    } catch (e) {
      log('Error fetching question count: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Map<String, dynamic>>>> fetchCustomExams(
      {int page = 1, int limit = 10}) async {
    try {
      final response = await get('custom-exams/?page=$page&limit=$limit');
      final body = response.body;

      if (response.statusCode == 200 && body is Map && body['success'] == true) {
        final List<dynamic> data = (body['data'] as List?) ?? [];
        final List<Map<String, dynamic>> customExams =
            data.map((item) => item as Map<String, dynamic>).toList();

        return Right(customExams);
      } else {
        return Left(CustomError(response.statusCode,
            message: _safeMsg(response, 'Failed to fetch custom exams')));
      }
    } catch (error) {
      log('fetchCustomExams error: $error');
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }

  // Helper method to validate profile image URLs coming from the API
  void _validateAndLogProfileImageUrl(String url, String source) {
    print(
        "DEBUG: ApiHelper._validateAndLogProfileImageUrl - Checking URL from $source: '$url'");

    if (url.isEmpty || url == 'null') {
      print(
          "WARNING: ApiHelper - Empty or 'null' string profile image URL from $source");
      return;
    }

    try {
      final uri = Uri.parse(url.trim());
      if (!uri.isAbsolute) {
        print(
            "WARNING: ApiHelper - Non-absolute profile image URL from $source: '$url'");
      }

      if (!uri.scheme.startsWith('http') && !uri.scheme.startsWith('https')) {
        print(
            "WARNING: ApiHelper - Invalid scheme in profile image URL from $source: '${uri.scheme}'");
      }

      print(
          "DEBUG: ApiHelper - Profile image URL from $source looks valid: '$url'");
    } catch (e) {
      print(
          "WARNING: ApiHelper - Invalid profile image URL format from $source: '$url', Error: $e");
    }
  }
}
