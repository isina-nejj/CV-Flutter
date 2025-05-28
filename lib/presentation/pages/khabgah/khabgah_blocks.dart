import 'package:flutter/material.dart';
import '../../../core/style/colors.dart';
import '../../../core/style/text_styles.dart';
import '../../../core/style/sizes.dart';
import '../../../core/theme/dark_mode_controller.dart';
import 'khabgah_floors.dart';

class KhabgahBlocksPage extends StatelessWidget {
  const KhabgahBlocksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final blocks = ['بلوک 1', 'بلوک 2', 'بلوک 3'];
    final darkMode = DarkModeController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'بلوک های خوابگاه',
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
        child: GridView.builder(
          padding: AppSizes.pagePadding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: AppSizes.gridSpacing,
            mainAxisSpacing: AppSizes.gridSpacing,
          ),
          itemCount: blocks.length,
          itemBuilder: (context, index) {
            return InkWell(
              borderRadius: AppSizes.defaultRadius,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        KhabgahFloorsPage(blockName: blocks[index]),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: darkMode.isDarkMode
                      ? AppColors.darkBlockBackground
                      : AppColors.blockBackground,
                  borderRadius: AppSizes.defaultRadius,
                  border: Border.all(
                    color: darkMode.isDarkMode
                        ? AppColors.darkBlockBorder
                        : AppColors.blockBorder,
                    width: 2,
                  ),
                  boxShadow: darkMode.isDarkMode ? [] : AppSizes.cardShadow,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: AppSizes.defaultRadius,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: darkMode.isDarkMode
                                ? [
                                    AppColors.darkDormitoryStartColor
                                        .withOpacity(0.1),
                                    AppColors.darkDormitoryEndColor
                                        .withOpacity(0.05),
                                  ]
                                : [
                                    AppColors.dormitoryStartColor
                                        .withOpacity(0.1),
                                    AppColors.dormitoryEndColor
                                        .withOpacity(0.05),
                                  ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.domain,
                            size: 48,
                            color: darkMode.isDarkMode
                                ? AppColors.darkBlockBorder
                                : AppColors.blockBorder,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            blocks[index],
                            style:
                                AppTextStyles.blockTitle(darkMode.isDarkMode),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
