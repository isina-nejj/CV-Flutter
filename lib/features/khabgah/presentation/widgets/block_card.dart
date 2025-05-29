import 'package:flutter/material.dart';
import '../../../../../shared/widgets/custom_card.dart';
import '../../../../core/style/text_styles.dart';
import '../../../../core/theme/dark_mode_controller.dart';

class BlockCard extends StatelessWidget {
  final String blockName;
  final DarkModeController darkMode;
  final VoidCallback onTap;

  const BlockCard({
    super.key,
    required this.blockName,
    required this.darkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      darkMode: darkMode,
      onTap: onTap,
      child: Center(
        child: Text(
          blockName,
          style: AppTextStyles.blockName(darkMode.isDarkMode),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
