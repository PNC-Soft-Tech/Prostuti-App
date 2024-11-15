import 'package:dartz/dartz.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:prostuti/app/APIs/custom_error.dart';

import '../constant/app_config.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/register/models/register_model.dart';
import 'api_helper.dart';

class ApiHelperImpl extends GetConnect implements ApiHelper {
  @override
  void onInit() {
    httpClient.baseUrl = AppConfig.baseUrl;
    httpClient.timeout = Duration(seconds: AppConfig.timeoutDuration);
  }

  Future<Either<CustomError, T>> _convert<T>(
      Response response, T Function(Map<String, dynamic>) fromJson) async {
    if (response.statusCode == 200) {
      try {
        return Right(fromJson(response.body));
      } catch (e) {
        return Left(CustomError(response.statusCode, message: 'Parsing error: $e'));
      }
    } else {
      return Left(CustomError(response.statusCode, message: '${response.statusText}'));
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
      return Left(CustomError(response.statusCode, message: '${response.statusText}'));
    }
  }

    @override
  Future<Either<CustomError, LoginResponseModel>> login(
      LoginRequestModel payload) async {
    final response = await post('users/login', payload.toJson());

    // Use the `_convert` helper function to handle the parsing
    return _convert(response, LoginResponseModel.fromJson);
  }
}
