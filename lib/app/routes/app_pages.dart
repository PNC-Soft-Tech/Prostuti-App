import 'package:get/get.dart';
import 'package:prostuti/app/modules/contest-details/binding/contest_details_binding.dart';
import 'package:prostuti/app/modules/contest-details/view/contest_details_view.dart';
import 'package:prostuti/app/modules/onboarding/views/onboarding_view.dart';
import 'package:prostuti/app/modules/profile/bindings/profile_binding.dart';
import 'package:prostuti/app/modules/profile/view/profile_edit_view.dart';
import 'package:prostuti/app/modules/profile/view/profile_view.dart';
import 'package:prostuti/app/modules/register/bindings/register_binding.dart';
import 'package:prostuti/app/modules/register/views/register_view.dart';
import 'package:prostuti/app/modules/splash/views/splash_view.dart';
import '../modules/contests/bindings/contest_binding.dart';
import '../modules/contests/views/contest_view.dart';
import '../modules/custom-exam/binding/custom_exam_binding.dart';
import '../modules/custom-exam/view/custom_exam_view.dart';
import '../modules/email_varification/binding/email_varification_binding.dart';
import '../modules/email_varification/view/email_varification_view.dart';
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
import '../modules/questions/bindings/question_bindings.dart';
import '../modules/questions/views/question_view.dart';

class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const register = '/register';
  static const emailVarification = '/email-varification';
  static const login = '/login';
  static const profile = '/profile';
  static const profileEdit = '/profile-edit';
  static const home = '/home';
  static const jobCircular = '/job-circulars';
  static const jobCategories = '/job-categories';
  static const examTypes = '/exam-types';
  static const customExam = '/custom-exam';
  static const questions = '/questions';
  static const contests = '/contests';
  static const contestDetails = '/contest-details/';
  // Dynamic route generator for single contest
  static String singleContest(String id) => '/contest/$id';
}

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.emailVarification,
      page: () => const EmailVarificationView(),
      binding: EmailVarificationBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
        name: Routes.profile,
        page: () => const ProfileView(),
        binding: ProfileBinding()),
    GetPage(
      name: Routes.profileEdit,
      page: () => const ProfileEditView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.jobCircular,
      page: () => JobCircularView(),
      binding: JobCircularBinding(),
    ),
    GetPage(
      name: Routes.jobCategories,
      page: () => const JobCategoryView(),
      binding: JobCategoryBinding(),
    ),
    GetPage(
      name: Routes.examTypes,
      page: () => const ExamTypeView(),
      binding: ExamTypeBinding(),
    ),
    GetPage(
      name: Routes.customExam,
      page: () => const CustomExamView(),
      binding: CustomExamBinding(),
    ),
    GetPage(
      name: '/contests',
      page: () => const ContestView(),
      binding: ContestBinding(),
    ),
    GetPage(
      // name: '/contest/:id',
      name: '/contest-details/',
      page: () => const ContestDetailsView(),
      binding: ContestDetailsBinding(),
    ),
    GetPage(
      name: '/questions',
      page: () => const QuestionView(),
      binding: QuestionBinding(),
    ),
  ];
}
