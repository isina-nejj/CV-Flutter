import 'package:flutter/material.dart';
import '../../../core/style/text_styles.dart';
import '../../../core/theme/dark_mode_controller.dart';
import '../../../core/style/colors.dart';
import '../../../data/services/hive_service.dart';

class SchedulePage extends StatelessWidget {
  final HiveService hiveService;

  const SchedulePage({
    super.key,
    required this.hiveService,
  });

  @override
  Widget build(BuildContext context) {
    final darkMode = DarkModeController();

    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) => Text(
            'برنامه کلاسی',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: darkMode.isDarkMode
            ? AppColors.darkAppBarBackground
            : AppColors.appBarBackground,
        actions: [
          DarkModeToggle(controller: darkMode),
        ],
      ),
      body: Container(
        color: darkMode.isDarkMode
            ? AppColors.darkScheduleBackground
            : AppColors.white,
        child: Center(
          child: Text(
            'صفحه برنامه کلاسی',
            style: AppTextStyles.schedulePageTitle.copyWith(
              color:
                  darkMode.isDarkMode ? AppColors.darkText : AppColors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
