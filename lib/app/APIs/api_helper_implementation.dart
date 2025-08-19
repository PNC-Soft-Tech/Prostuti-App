
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
  @override
  Future<Either<CustomError, Response<dynamic>>> register(
      RegisterRequestModel register) async {
    final response = await post('users', register.toJson());

    if (response.statusCode == 200) {
      return Right(response);
    } else {
      return Left(CustomError(response.statusCode,
          message: '${response.body['message']}'));
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
        // Handle nested data structure: response.body['data']['data']
        final responseData = response.body['data'];
        List<ExamType> examTypes;
        
        if (responseData is Map && responseData['data'] is List) {
          // Nested structure: {success: true, data: {data: [...], total: 5, ...}}
          examTypes = responseData['data']
              .map((item) => ExamType.fromJson(item))
              .toList();
        } else if (responseData is List) {
          // Direct array structure: {success: true, data: [...]}
          examTypes = responseData
              .map((item) => ExamType.fromJson(item))
              .toList();
        } else {
          throw Exception('Unexpected data structure in exam-types response');
        }
        
        log('✅ Parsed ${examTypes.length} exam types successfully');
        return Right(examTypes);
      } catch (e) {
        log('❌ Error parsing exam types: $e');
        return Left(
            CustomError(response.statusCode, message: 'Parsing error: $e'));
      }
    } else {
      return Left(CustomError(response.statusCode,
          message: response.statusText ?? 'Error'));
    }
  }

  @override
  Future<Either<CustomError, List<ExamType>>> getExamTypesByCategory(String category) async {
    final response = await get('exam-types?category=$category');
    if (response.statusCode == 200) {
      try {
        // Debug: Log the actual response structure
        log('🔍 API Response for exam-types?category=$category: ${response.body}');
        
        // Handle nested data structure: response.body['data']['data']
        final responseData = response.body['data'];
        log('🔍 ResponseData type: ${responseData.runtimeType}, content: $responseData');
        List<ExamType> examTypes;
        
        if (responseData is Map && responseData['data'] is List) {
          // Nested structure: {success: true, data: {data: [...], total: 5, ...}}
          final dataList = responseData['data'] as List;
          examTypes = dataList
              .map((item) => ExamType.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (responseData is List) {
          // Direct array structure: {success: true, data: [...]}
          examTypes = responseData
              .map((item) => ExamType.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected data structure in exam-types response');
        }
        
        log('✅ Parsed ${examTypes.length} exam types for category $category successfully');
        return Right(examTypes);
      } catch (e) {
        log('❌ Error parsing exam types for category $category: $e');
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
  Future<Either<CustomError, List<Contest>>> fetchContestHistory() async {
    try {
      final response = await get('contest-points/history');
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final contests = data
            .where((json) => json['contest'] != null) // Filter out null contests
            .map((json) => Contest.fromJson(json['contest']))
            .toList();
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ??
                'Failed to fetch contests history'));
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
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        // log("model dataaa: ${data?.length}");
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
            message:
                response.body['message'] ?? 'Failed to fetch user profile'));
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

      if (response.statusCode == 200 && response.body['success'] == true) {
        final updatedData = response.body['data'] as Map<String, dynamic>;
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
            message:
                response.body['message'] ?? 'Failed to update user profile'));
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
  Future<Either<CustomError, List<Contest>>> fetchRecentContests() async {
    try {
      // Make the GET request to fetch recent contests
      final response = await get('contests/?contestType=recent');

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
          final data =
              CustomExamDetailsResponse.fromJson(response.body['data']);
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
  Future<Either<CustomError, List<InstitutionType>>>
      getInstitutionTypes() async {
    try {
      final response = await get('institution-types/');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        final List<InstitutionType> institutionTypes = data
            .map((item) =>
                InstitutionType.fromJson(item as Map<String, dynamic>))
            .toList();

        return Right(institutionTypes);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ??
                'Failed to fetch institution types'));
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
    required List<String> selectedAnswers,
  }) async {
    try {
      // Prepare the payload
      final payload = {
        "question": questionId,
        "contest": contestId,
        "selectedAnswers": selectedAnswers,
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
  Future<Either<CustomError, Response>> submitCustomExamAnswers({
    required String questionId,
    required String customExamId,
    required String selectedAnswers,
  }) async {
    try {
      // Prepare the payload - selectedAnswers as string
      final payload = {
        "question": questionId,
        "customExam": customExamId,
        "selectedAnswers": selectedAnswers,
      };
      log("Custom Exam Answer payload: $payload");
      
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

      // Make the POST request to custom-exam-answers endpoint
      final response = await post('custom-exam-answers', payload, headers: headers);

      // Log for debugging
      log('Submit Custom Exam Answer Response: ${response.statusCode}, Body: ${response.body}');

      // Handle response
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response); // Successful response
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Failed to submit custom exam answer',
        ));
      }
    } catch (e) {
      log('Error submitting custom exam answer: $e');
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
      final response =
          await post('custom-exams/generate-contest', payload.toJson());
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response);
      } else {
        return Left(CustomError(response.statusCode,
            message:
                response.body['message'] ?? 'Failed to generate custom exam'));
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

      if (response.statusCode == 200 && response.body['success'] == true) {
        // The API returns count in the 'count' field, not 'data'
        final count = response.body['count'] as int? ?? 0;
        return Right(count);
      } else {
        return Left(CustomError(response.statusCode,
            message:
                response.body['message'] ?? 'Failed to fetch question count'));
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

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        final List<Map<String, dynamic>> customExams =
            data.map((item) => item as Map<String, dynamic>).toList();

        return Right(customExams);
      } else {
        return Left(CustomError(response.statusCode,
            message:
                response.body['message'] ?? 'Failed to fetch custom exams'));
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
      }      print(
          "DEBUG: ApiHelper - Profile image URL from $source looks valid: '$url'");
    } catch (e) {
      print(
          "WARNING: ApiHelper - Invalid profile image URL format from $source: '$url', Error: $e");
    }
  }

  // Corner-specific filtered API methods with category and examType
  @override
  Future<Either<CustomError, List<Contest>>> fetchContestsByCategory({
    required String category,
    String examType = '',
  }) async {
    try {
      final response = await get('contests/?category=$category&examType=$examType');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final contests = data.map((json) => Contest.fromJson(json)).toList();
        log('✅ Fetched ${contests.length} contests for category: $category, examType: $examType');
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch contests by category'));
      }
    } catch (e) {
      log('Error fetching contests by category: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<ModelTest>>> fetchModelTestsByCategory({
    required String category,
    String examType = '',
  }) async {
    try {
      final response = await get('models/?category=$category&examType=$examType');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final modelTests = data.map((json) => ModelTest.fromJson(json)).toList();
        log('✅ Fetched ${modelTests.length} model tests for category: $category, examType: $examType');
        return Right(modelTests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch model tests by category'));
      }
    } catch (e) {
      log('Error fetching model tests by category: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Map<String, dynamic>>>> fetchCustomExamsByCategory({
    required String category,
    String examType = '',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await get('custom-exams/?category=$category&examType=$examType&page=$page&limit=$limit');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        final List<Map<String, dynamic>> customExams =
            data.map((item) => item as Map<String, dynamic>).toList();
        
        log('✅ Fetched ${customExams.length} custom exams for category: $category, examType: $examType');
        return Right(customExams);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch custom exams by category'));
      }
    } catch (error) {
      log('fetchCustomExamsByCategory error: $error');
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }

  // Legacy corner-specific filtered API methods (deprecated)
  @override
  Future<Either<CustomError, List<Contest>>> fetchFilteredContests(String contestType) async {
    try {
      final response = await get('contests/?contestType=$contestType');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final contests = data.map((json) => Contest.fromJson(json)).toList();
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch filtered contests'));
      }
    } catch (e) {
      log('Error fetching filtered contests: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<ModelTest>>> fetchFilteredModelTests(String modelType) async {
    try {
      final response = await get('models/?modelType=$modelType');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final modelTests = data.map((json) => ModelTest.fromJson(json)).toList();
        return Right(modelTests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch filtered model tests'));
      }
    } catch (e) {
      log('Error fetching filtered model tests: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Map<String, dynamic>>>> fetchFilteredCustomExams({
    required String customExamTypeFilter,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await get('custom-exams/?customExamType=$customExamTypeFilter&page=$page&limit=$limit');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        final List<Map<String, dynamic>> customExams =
            data.map((item) => item as Map<String, dynamic>).toList();

        return Right(customExams);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch filtered custom exams'));
      }
    } catch (error) {
      log('fetchFilteredCustomExams error: $error');
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }

  // ExamType-based filtered API methods
  @override
  Future<Either<CustomError, List<Contest>>> fetchContestsByExamType(String examType) async {
    try {
      final response = await get('contests/?category=$examType');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final contests = data.map((json) => Contest.fromJson(json)).toList();
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch contests by examType'));
      }
    } catch (e) {
      log('Error fetching contests by examType: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<ModelTest>>> fetchModelTestsByExamType(String examType) async {
    try {
      final response = await get('models/?category=$examType');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final modelTests = data.map((json) => ModelTest.fromJson(json)).toList();
        return Right(modelTests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch model tests by examType'));
      }
    } catch (e) {
      log('Error fetching model tests by examType: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Map<String, dynamic>>>> fetchCustomExamsByExamType({
    required String examType,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await get('custom-exams/?category=$examType&page=$page&limit=$limit');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        final List<Map<String, dynamic>> customExams =
            data.map((item) => item as Map<String, dynamic>).toList();

        return Right(customExams);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch custom exams by examType'));
      }
    } catch (error) {
      log('fetchCustomExamsByExamType error: $error');
      return Left(CustomError(500, message: 'Internal server error'));
    }
  }

  // Token validation API
  @override
  Future<Either<CustomError, Map<String, dynamic>>> validateToken() async {
    try {
      // Get token from storage
      final token = await StorageHelper.getToken();
      
      if (token == null) {
        log('No token found in storage');
        return Left(CustomError(401, message: 'No token found'));
      }

      // Make POST request to validate token
      final response = await post('users/validate-token', {});

      log('Token validation response: ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200 && response.body['success'] == true) {
        // Token is valid, return the token data
        final Map<String, dynamic> tokenData = response.body['data'] as Map<String, dynamic>;
        log('Token validation successful: ${tokenData}');
        return Right(tokenData);
      } else {
        // Token is invalid or expired
        log('Token validation failed: ${response.body['message'] ?? 'Token is invalid'}');
        
        // Clear invalid token from storage
        await StorageHelper.removeToken();
        
        return Left(CustomError(
          response.statusCode ?? 401,
          message: response.body['message'] ?? 'Token is invalid or expired',
        ));
      }
    } catch (e) {
      log('Error validating token: $e');
      
      // Clear token on network error as well (could be expired/malformed)
      await StorageHelper.removeToken();
      
      return Left(CustomError(500, message: 'Network error during token validation: $e'));
    }
  }

  // Payment and Subscription API implementations
  @override
  Future<Either<CustomError, Map<String, dynamic>>> initiateBkashPayment(Map<String, dynamic> paymentData) async {
    try {
      final token = await StorageHelper.getToken();
      
      if (token == null) {
        return Left(CustomError(401, message: 'Unauthorized: No token found'));
      }

      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await post('payments/bkash/initiate', paymentData, headers: headers);
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response.body['data'] as Map<String, dynamic>);
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Failed to initiate bKash payment',
        ));
      }
    } catch (e) {
      log('Error initiating bKash payment: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, Map<String, dynamic>>> verifyBkashPayment(String paymentId, String transactionId) async {
    try {
      final token = await StorageHelper.getToken();
      
      if (token == null) {
        return Left(CustomError(401, message: 'Unauthorized: No token found'));
      }

      final headers = {
        'Authorization': 'Bearer $token',
      };

      final payload = {
        'paymentId': paymentId,
        'transactionId': transactionId,
      };

      final response = await post('payments/bkash/verify', payload, headers: headers);
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response.body['data'] as Map<String, dynamic>);
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Failed to verify bKash payment',
        ));
      }
    } catch (e) {
      log('Error verifying bKash payment: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, Map<String, dynamic>>> getSubscriptionStatus(String userId) async {
    try {
      final token = await StorageHelper.getToken();
      
      if (token == null) {
        return Left(CustomError(401, message: 'Unauthorized: No token found'));
      }

      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await get('subscriptions/status/$userId', headers: headers);
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response.body['data'] as Map<String, dynamic>);
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Failed to get subscription status',
        ));
      }
    } catch (e) {
      log('Error getting subscription status: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Map<String, dynamic>>>> getAvailablePackages() async {
    try {
      final response = await get('packages/available');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'] as List<dynamic>;
        final List<Map<String, dynamic>> packages =
            data.map((item) => item as Map<String, dynamic>).toList();
        return Right(packages);
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Failed to get available packages',
        ));
      }
    } catch (e) {
      log('Error getting available packages: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, Map<String, dynamic>>> activateSubscription(Map<String, dynamic> subscriptionData) async {
    try {
      final token = await StorageHelper.getToken();
      
      if (token == null) {
        return Left(CustomError(401, message: 'Unauthorized: No token found'));
      }

      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await post('subscriptions/activate', subscriptionData, headers: headers);
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        return Right(response.body['data'] as Map<String, dynamic>);
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Failed to activate subscription',
        ));
      }
    } catch (e) {
      log('Error activating subscription: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }
}
