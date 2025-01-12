import 'package:get/get.dart';

import '../../../storage/storage_helper.dart';

class ProfileController extends GetxController {
  var title = 'Profile Page'.obs;
  final userId = ''.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    userId.value = await StorageHelper.getUserId() ?? '';
  }

  RxInt currentIndex = 0.obs;
  void updateTitle(String newTitle) {
    title.value = newTitle;
  }
}
