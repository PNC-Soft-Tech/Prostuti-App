import 'package:get/get.dart';
import 'package:prostuti/app/modules/onboarding/views/onboarding_view.dart';
import 'package:prostuti/app/modules/register/bindings/register_binding.dart';
import 'package:prostuti/app/modules/register/views/register_view.dart';
import 'package:prostuti/app/modules/splash/views/splash_view.dart';
import '../modules/home/binding/home_binding.dart';
import '../modules/home/view/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

class AppPages {
  static const initial = Routes.register;

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
      name: Routes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}

class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const register = '/register';
  static const login = '/login';
  static const home = '/home';
}
