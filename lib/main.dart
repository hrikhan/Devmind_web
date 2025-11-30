import 'package:devmind/app/controllers/auth_controller.dart';
import 'package:devmind/app/controllers/portfolio_controller.dart';
import 'package:devmind/app/controllers/task_controller.dart';
import 'package:devmind/app/routes/app_pages.dart';
import 'package:devmind/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024), // Web design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'DevMind',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          defaultTransition: Transition.fadeIn,
          initialBinding: BindingsBuilder(() {
            Get.put(AuthController(), permanent: true);
            Get.put(PortfolioController(), permanent: true);
            Get.put(TaskController(), permanent: true);
          }),
        );
      },
    );
  }
}
