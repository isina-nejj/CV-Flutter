import 'package:flutter/material.dart';
import '../../../core/style/colors.dart';
import '../../../core/style/text_styles.dart';
import '../../../core/theme/dark_mode_controller.dart';

class KhabgahRoomDetailsPage extends StatelessWidget {
  final String blockName;
  final String floorName;
  final int roomNumber;

  const KhabgahRoomDetailsPage({
    super.key,
    required this.blockName,
    required this.floorName,
    required this.roomNumber,
  });

  @override
  Widget build(BuildContext context) {
    final darkMode = DarkModeController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'اتاق $roomNumber',
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
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مشخصات اتاق:',
              style: AppTextStyles.floorTitle(darkMode.isDarkMode),
            ),
            const SizedBox(height: 16),
            Card(
              color: darkMode.isDarkMode ? Colors.grey[800] : Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('بلوک:', blockName),
                    const SizedBox(height: 8),
                    _buildDetailRow('طبقه:', floorName),
                    const SizedBox(height: 8),
                    _buildDetailRow('شماره اتاق:', roomNumber.toString()),
                    const SizedBox(height: 8),
                    _buildDetailRow('ظرفیت:', '4 نفر'),
                    const SizedBox(height: 8),
                    _buildDetailRow('وضعیت:', 'خالی'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'ساکنین:',
              style: AppTextStyles.floorTitle(darkMode.isDarkMode),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 0, // Will be populated with actual residents
                itemBuilder: (context, index) {
                  return Card(
                    color:
                        darkMode.isDarkMode ? Colors.grey[800] : Colors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('نام دانشجو $index'),
                      subtitle: Text('شماره دانشجویی'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
