import 'package:flutter/material.dart';
import '../../../../core/style/colors.dart';
import '../../../../core/theme/dark_mode_controller.dart';
import '../../../../shared/widgets/custom_card.dart';

class DormitoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool showGradient;

  const DormitoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.showGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    final darkMode = DarkModeController();
    final isDark = darkMode.isDarkMode;

    return CustomCard(
      darkMode: darkMode,
      onTap: onTap,
      child: Stack(
        children: [
          if (showGradient)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            AppColors.darkDormitoryStartColor.withOpacity(0.1),
                            AppColors.darkDormitoryEndColor.withOpacity(0.05),
                          ]
                        : [
                            AppColors.dormitoryStartColor.withOpacity(0.1),
                            AppColors.dormitoryEndColor.withOpacity(0.05),
                          ],
                  ),
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: isDark ? AppColors.darkPrimary : AppColors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: isDark ? AppColors.darkText : AppColors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.black54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
