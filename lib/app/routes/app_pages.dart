import 'package:get/get.dart';
import '../modules/exam-types/bindings/exam-type-binding.dart';
import '../modules/exam-types/views/exam-type-view.dart';
import '../modules/home/binding/home_binding.dart';
import '../modules/home/view/home_view.dart';
import '../modules/job-category/bindings/job-category-binding.dart';
import '../modules/job-category/views/job-category-view.dart';
import '../modules/job-circulars/bindings/job-circulars-binding.dart';
import '../modules/job-circulars/views/job-circulars-view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.jobCircular,
      page: () => JobCircularView(),
      binding: JobCircularBinding(),
    ),
    GetPage(
      name: Routes.jobCategories,
      page: () => JobCategoryView(),
      binding: JobCategoryBinding(),
    ),
    GetPage(
      name: Routes.examTypes,
      page: () => ExamTypeView(),
      binding: ExamTypeBinding(),
    ),
  ];
}

class Routes {
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const jobCircular = '/job-circulars';
  static const jobCategories = '/job-categories';
  static const examTypes = '/exam-types';
}
