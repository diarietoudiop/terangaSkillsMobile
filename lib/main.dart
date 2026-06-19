import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/constants/app_constants.dart';
import 'core/services/connectivity_service.dart';
import 'core/theme/app_theme.dart';
import 'modules/auth/controller/auth_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init local storage
  await GetStorage.init();

  // Init Connectivity Service
  Get.put(ConnectivityService(), permanent: true);

  // Init Auth Controller globally
  Get.put(AuthController(), permanent: true);

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const TerangaSkillsApp());
}

class TerangaSkillsApp extends StatelessWidget {
  const TerangaSkillsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    const initialRoute = AppRoutes.splash;

    final isDark = storage.read<bool>('is_dark_mode');
    final ThemeMode initialThemeMode;
    if (isDark == null) {
      initialThemeMode = ThemeMode.system;
    } else {
      initialThemeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    return GetMaterialApp(
      title: 'TerangaSkills',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: initialThemeMode,

      // Routing
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),

      // Locale
      locale: const Locale('fr', 'FR'),
      fallbackLocale: const Locale('fr', 'FR'),
    );
  }
}
