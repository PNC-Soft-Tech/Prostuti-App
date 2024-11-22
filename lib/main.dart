import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/APIs/api_helper.dart';
import 'app/APIs/api_helper_implementation.dart';
import 'app/APIs/global-binding/global-binding.dart';
import 'app/common/themes/theme_controller.dart';
import 'app/constant/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp( MainApp());
}

class MainApp extends StatelessWidget {
   MainApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX MVC',
        debugShowCheckedModeBanner: false,
        theme: themeController.currentTheme,
        darkTheme: ThemeData.dark(),
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: GlobalBinding(),
    );
  }
}
