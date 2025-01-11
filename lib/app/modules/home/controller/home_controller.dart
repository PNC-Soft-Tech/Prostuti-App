import 'package:get/get.dart';

import '../../../storage/storage_helper.dart';

class HomeController extends GetxController {
  var title = 'Home Page'.obs;
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
