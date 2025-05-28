import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/dark_mode_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/app_localizations.dart';
import 'data/models/course_model.dart';
import 'data/models/section_model.dart';
import 'data/services/hive_service.dart';
import 'presentation/pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(CourseModelAdapter());
  Hive.registerAdapter(SectionModelAdapter());

  // Open Hive Boxes
  await Hive.openBox('courses');
  await Hive.openBox('sections');
  await Hive.openBox('lastUpdate');

  // Initialize Services
  final hiveService = HiveService();
  await hiveService.init();

  final darkModeController = DarkModeController();
  await darkModeController.init();

  runApp(MyApp(
    darkModeController: darkModeController,
    hiveService: hiveService,
  ));
}

class MyApp extends StatelessWidget {
  final DarkModeController darkModeController;
  final HiveService hiveService;

  const MyApp({
    super.key,
    required this.darkModeController,
    required this.hiveService,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: darkModeController,
      builder: (context, child) {
        return MaterialApp(
          title: 'UniPath',
          locale: AppLocalizations.supportedLocales.first,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.delegates,
          theme: AppTheme.getTheme(darkModeController.themeData.colorScheme),
          home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Image.asset(
                  'assets/logo/logo.png',
                  height: 40,
                ),
              ),
              body: MainPage(hiveService: hiveService),
            ),
          ),
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        );
      },
    );
  }
}
