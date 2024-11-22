import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/APIs/api_helper.dart';
import 'app/APIs/api_helper_implementation.dart';
import 'app/APIs/global-binding/global-binding.dart';
import 'app/constant/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX MVC',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      
        initialBinding: GlobalBinding(),
    );
  }
}
