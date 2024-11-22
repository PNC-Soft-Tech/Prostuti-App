import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:prostuti/app/APIs/custom_error.dart';

import '../constant/app_config.dart';
import '../models/job-category-model.dart';
import '../modules/exam-types/models/exam-type-model.dart';
import '../modules/job-circulars/models/job-circulars-model.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/register/models/register_model.dart';
import 'api_helper.dart';

class ApiHelperImpl extends GetConnect implements ApiHelper {
  @override
  void onInit() {
    super.onInit(); // Ensure this is called to properly set up GetConnect.

    log("url: ${AppConfig.baseUrl + AppConfig.apiVersion + '/'}");
    httpClient.baseUrl = AppConfig.baseUrl + AppConfig.apiVersion + '/';
    httpClient.timeout = Duration(seconds: AppConfig.timeoutDuration);
    log("ApiHelperImpl initialized with baseUrl: ${httpClient.baseUrl}");
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<Object?>((request) {
      log('Request: ${request.method} ${request.url}');
      log('Headers: ${request.headers}');
      log('Body: ${request.bodyBytes}');
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
  Future<Either<CustomError, List<JobCircular>>> fetchJobCirculars() async {
    try {
      final response = await get('job-circulars');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['data'];
        final jobCirculars =
            data.map((json) => JobCircular.fromJson(json)).toList();
        return Right(jobCirculars);
      } else {
        return Left(CustomError(response.statusCode,
            message: "${response.statusCode}"));
      }
    } catch (e) {
      return Left(CustomError(500, message: 'An error occurred: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<JobCategory>>> getJobCategories() async {
    // final baseUrl = httpClient.baseUrl ?? 'unknown';
    // log('url: ${baseUrl}job-categories');
     log("Base URL being used: ${httpClient.baseUrl}"); // Debugging
    // final baseUrl = httpClient.baseUrl ?? '${AppConfig.baseUrl}${AppConfig.apiVersion}/';
    try {
      // log('Making API call to: ${baseUrl}job-categories/');
      Response response = await get('job-categories/');
      log('API response status: 1 ${response.statusCode}, body: ${response.body}');
      if (response.statusCode == null) response = await get("job-categories/");
      if (response.statusCode == null) response = await get("job-categories/");
      if (response.statusCode == null) response = await get("job-categories/");
      log('API response status: ${response.statusCode}, body: ${response.body}');
      if (response.statusCode == 200) {
        List<JobCategory> categories = (response.body['data'] as List)
            .map((item) => JobCategory.fromJson(item))
            .toList();
        return Right(categories);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.statusText ?? 'Error'));
      }
    } catch (e) {
      log('API error: $e');
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
}
