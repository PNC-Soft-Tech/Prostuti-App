import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../modules/job-circulars/models/job-circulars-model.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/register/models/register_model.dart';
import 'custom_error.dart';

abstract class ApiHelper {
  // Future<Either<CustomError, LoginResponse>> login(LoginRequestModel login);
  Future<Either<CustomError, LoginResponseModel>> login(LoginRequestModel payload);

  Future<Either<CustomError, Response>> register(RegisterRequestModel register);
  Future<Either<CustomError, List<JobCircular>>> fetchJobCirculars();
  // Future<Either<CustomError, UserProfile>> getUserProfile(String userId);
  // Add other API methods as needed
}
