import 'package:flutter/material.dart';
import '../../../data/services/hive_service.dart';

class CourseSelectionPageDesktop extends StatelessWidget {
  final HiveService hiveService;

  const CourseSelectionPageDesktop({
    super.key,
    required this.hiveService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('انتخاب دروس - دسکتاپ'),
      ),
      body: const Center(
        child: Text('صفحه انتخاب دروس برای دسکتاپ/وب/تبلت'),
      ),
    );
  }
}
