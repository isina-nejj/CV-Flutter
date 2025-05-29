import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../core/style/text_styles.dart';

import '../../../../core/theme/dark_mode_controller.dart';

class ResidentsList extends StatelessWidget {
  final String title;
  final List<String> residents;
  final DarkModeController darkMode;
  final IconData icon;

  const ResidentsList({
    super.key,
    required this.title,
    required this.residents,
    required this.darkMode,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      darkMode: darkMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: darkMode.isDarkMode ? Colors.white70 : Colors.black87,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.body(darkMode.isDarkMode),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (residents.isEmpty)
            Text(
              'هیچ ساکنی ثبت نشده است',
              style: AppTextStyles.body(darkMode.isDarkMode),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: residents.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    residents[index],
                    style: AppTextStyles.body(darkMode.isDarkMode),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
