import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../storage/storage_helper.dart';

class ProfileController extends GetxController {
  var title = 'Profile Page'.obs;
  final userId = ''.obs;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    userId.value = await StorageHelper.getUserId() ?? '';
    // Initialize with the profile tab selected
    currentIndex.value = 4; // Set to profile tab index
  }

  RxInt currentIndex = 4.obs; // Default to profile tab index
  
  // Navigate based on bottom nav index
  void navigateToIndex(int index) {
    if (index == currentIndex.value) return; // Already on this page
    
    // Update the currentIndex
    currentIndex.value = index;
    
    // Navigate to appropriate page
    switch (index) {
      case 0: // Home
        Get.offAllNamed(Routes.home);
        break;
      case 1: // Search
        Get.offAllNamed(Routes.search);
        break;
      case 2: // Ranking
        Get.offAllNamed(Routes.ranking);
        break;
      case 3: // History
        Get.toNamed(Routes.home, arguments: {'tabIndex': 3});
        break;
      case 4: // Profile or More
        // Already on profile, no need to navigate
        break;
    }
  }
  
  void updateTitle(String newTitle) {
    title.value = newTitle;
  }
}
