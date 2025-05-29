import 'package:flutter/material.dart';
import '../../../../core/style/colors.dart';
import '../../../../core/style/text_styles.dart';
import '../../../../core/theme/dark_mode_controller.dart';
import '../../../../shared/widgets/dark_mode_toggle.dart';
import '../../../../shared/utils/constants.dart';

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
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مشخصات اتاق:',
              style: AppTextStyles.floorTitle(darkMode.isDarkMode),
            ),
            SizedBox(height: AppConstants.defaultMargin),
            Card(
              color: darkMode.isDarkMode ? Colors.grey[800] : Colors.white,
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('بلوک:', blockName),
                    SizedBox(height: AppConstants.defaultMargin / 2),
                    _buildDetailRow('طبقه:', floorName),
                    SizedBox(height: AppConstants.defaultMargin / 2),
                    _buildDetailRow('شماره اتاق:', roomNumber.toString()),
                    SizedBox(height: AppConstants.defaultMargin / 2),
                    _buildDetailRow('نوع اتاق:',
                        AppConstants.roomTypes['quad'] ?? 'چهار نفره'),
                    SizedBox(height: AppConstants.defaultMargin / 2),
                    _buildDetailRow(
                        'ظرفیت:', '${AppConstants.maxRoomCapacity} نفر'),
                    SizedBox(height: AppConstants.defaultMargin / 2),
                    _buildDetailRow('وضعیت:', 'خالی'),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppConstants.defaultMargin * 1.5),
            Text(
              'ساکنین:',
              style: AppTextStyles.floorTitle(darkMode.isDarkMode),
            ),
            SizedBox(height: AppConstants.defaultMargin),
            Expanded(
              child: ListView.builder(
                itemCount: 0,
                itemBuilder: (context, index) {
                  return Card(
                    color:
                        darkMode.isDarkMode ? Colors.grey[800] : Colors.white,
                    margin:
                        EdgeInsets.only(bottom: AppConstants.defaultMargin / 2),
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
