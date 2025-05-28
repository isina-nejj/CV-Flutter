import 'package:flutter/material.dart';
import '../../../core/style/colors.dart';
import '../../../core/style/text_styles.dart';
import '../../../core/style/sizes.dart';
import '../../../core/theme/dark_mode_controller.dart';
import 'khabgah_floor_map.dart';

class KhabgahFloorsPage extends StatelessWidget {
  final String blockName;

  const KhabgahFloorsPage({
    super.key,
    required this.blockName,
  });
  @override
  Widget build(BuildContext context) {
    final floors = ['طبقه همکف', 'طبقه اول', 'طبقه دوم'];
    final darkMode = DarkModeController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$blockName - طبقات',
          style: AppTextStyles.blockTitle(darkMode.isDarkMode),
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
        color: darkMode.isDarkMode ? AppColors.darkBackground : AppColors.white,
        child: ListView.builder(
          padding: AppSizes.pagePadding,
          itemCount: floors.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: darkMode.isDarkMode
                  ? AppColors.darkFloorCardBackground
                  : AppColors.floorCardBackground,
              elevation: darkMode.isDarkMode ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: AppSizes.defaultRadius,
                side: BorderSide(
                  color: darkMode.isDarkMode
                      ? AppColors.darkFloorCardBorder
                      : AppColors.floorCardBorder,
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: AppSizes.defaultRadius,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KhabgahFloorMapPage(
                          blockName: blockName,
                          floorName: floors[index],
                        ),
                      ),
                    );
                  },
                  overlayColor: MaterialStateProperty.resolveWith((states) {
                    return states.contains(MaterialState.pressed)
                        ? (darkMode.isDarkMode
                            ? AppColors.darkDormitoryStartColor.withOpacity(0.1)
                            : AppColors.dormitoryStartColor.withOpacity(0.1))
                        : null;
                  }),
                  child: Padding(
                    padding: AppSizes.cardPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.apartment,
                          size: 32,
                          color: darkMode.isDarkMode
                              ? AppColors.darkFloorCardBorder
                              : AppColors.floorCardBorder,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          floors[index],
                          style: AppTextStyles.floorTitle(darkMode.isDarkMode),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'برای مشاهده اتاق‌ها کلیک کنید',
                          style: TextStyle(
                            fontSize: 12,
                            color: darkMode.isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
