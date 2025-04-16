import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/APIs/api_helper.dart';
import 'app/APIs/api_helper_implementation.dart';
import 'app/APIs/global-binding/global-binding.dart';
import 'app/common/themes/theme_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TeXRederingServer.renderingEngine = const TeXViewRenderingEngine.katex();

  /// ✅ Properly Initialize `TeXRederingServer`
  // if (!kIsWeb) {
  //   TeXRederingServer.renderingEngine = const TeXViewRenderingEngine.katex();
  //   await TeXRederingServer.run(); // 🔥 Start MathJax Server
  //   await Future.delayed(Duration(seconds: 2)); // 🔥 Give it time to initialize
  //   await TeXRederingServer.initController();
  // }
  // Initialize locale data
  await initializeDateFormatting('bn_BD', null);
  Get.lazyPut<ApiHelper>(() => ApiHelperImpl(), fenix: true);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(428, 926), // Set your design size
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Prostuti',
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
        });
  }
}
