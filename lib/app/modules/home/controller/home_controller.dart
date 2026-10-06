import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../storage/storage_helper.dart';

class HomeController extends GetxController {
  var title = 'Home Page'.obs;
  final userId = ''.obs;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    userId.value = await StorageHelper.getUserId() ?? '';
    
    // Check if we have arguments indicating which tab to select
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('tabIndex')) {
        currentIndex.value = args['tabIndex'];
      }
    }
  }

  RxInt currentIndex = 0.obs;
  
  // Navigate to a specific tab
  void navigateToTab(int index) {
    currentIndex.value = index;
  }
  
  // Navigate to profile
  void navigateToProfile() {
    Get.toNamed(Routes.profile);
  }
  
  void updateTitle(String newTitle) {
    title.value = newTitle;
  }
}
