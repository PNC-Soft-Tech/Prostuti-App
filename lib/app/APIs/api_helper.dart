import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import '../common/models/contest_model.dart';
import '../common/models/question_model.dart';
import '../models/job-category-model.dart';
import '../modules/exam-types/models/exam-type-model.dart';
import '../modules/job-circulars/models/job-circulars-model.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/register/models/register_model.dart';
import '../modules/single-contest/models/single_contest_model.dart';
import 'custom_error.dart';

abstract class ApiHelper {
  // Future<Either<CustomError, LoginResponse>> login(LoginRequestModel login);
  Future<Either<CustomError, LoginResponseModel>> login(LoginRequestModel payload);

  Future<Either<CustomError, Response>> register(RegisterRequestModel register);
  Future<Either<CustomError, List<JobCircular>>> fetchJobCirculars();
  Future<Either<CustomError, List<JobCategory>>> getJobCategories();
  Future<Either<CustomError, List<ExamType>>> getExamTypes();
  Future<Either<CustomError, List<Contest>>> fetchAllContests();
Future<Either<CustomError, List<Question>>> fetchAllQuestions();
Future<Either<CustomError, SingleContest>> fetchSingleContest(String contestId);

  // Future<Either<CustomError, UserProfile>> getUserProfile(String userId);


}
