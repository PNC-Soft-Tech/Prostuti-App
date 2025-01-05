import 'package:get/get.dart';

class HomeController extends GetxController {
  var title = 'Home Page'.obs;
RxInt currentIndex= 0.obs;
  void updateTitle(String newTitle) {
    title.value = newTitle;
  }
}
