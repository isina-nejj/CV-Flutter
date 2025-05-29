import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../core/style/text_styles.dart';
import '../../../../core/theme/dark_mode_controller.dart';

class RoomInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final DarkModeController darkMode;
  final IconData? icon;

  const RoomInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.darkMode,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      darkMode: darkMode,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon!,
              color: darkMode.isDarkMode ? Colors.white70 : Colors.black87,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle(darkMode.isDarkMode),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.cardSubtitle(darkMode.isDarkMode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
