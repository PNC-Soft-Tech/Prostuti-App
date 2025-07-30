import 'package:get/get.dart';

import '../../common/controller/app_controller.dart';
import '../../common/services/auth_service.dart';
import '../../common/widgets/breathing_animation/global_loading_manager.dart';
import '../api_helper.dart';
import '../api_helper_implementation.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppController>(() => AppController());
    // Ensure only one instance of ApiHelperImpl is created and globally accessible.
    Get.lazyPut<ApiHelper>(() => ApiHelperImpl());
    // Global AuthService for authentication checks
    Get.lazyPut<AuthService>(() => AuthService());
    // Global Loading Manager for consistent loading states
    Get.put<GlobalLoadingManager>(GlobalLoadingManager.instance);
    
    // Check authentication status on app startup
    _initializeAuthentication();
  }

  void _initializeAuthentication() async {
    // Wait a bit to ensure all dependencies are ready
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      final authService = Get.find<AuthService>();
      await authService.checkAuthenticationOnStartup();
    } catch (e) {
      print('GlobalBinding: Error initializing authentication - $e');
    }
  }
}
