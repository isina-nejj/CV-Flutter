import 'package:flutter/material.dart';
import '../../../../core/style/colors.dart';
import '../../../../core/theme/dark_mode_controller.dart';
import '../../../../data/services/hive_service.dart';

class CourseTimetablePage extends StatefulWidget {
  final List<int> selectedCourseIds;
  final HiveService hiveService;

  const CourseTimetablePage({
    super.key,
    required this.selectedCourseIds,
    required this.hiveService,
  });

  @override
  State<CourseTimetablePage> createState() => _CourseTimetablePageState();
}

class _CourseTimetablePageState extends State<CourseTimetablePage> {
  late final DarkModeController darkMode;
  final List<String> days = ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه'];
  final List<int> hours = List.generate(13, (index) => index + 8); // 8 تا 20
  List<Map<String, dynamic>> sections = [];

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeController();
    _loadCourseSections();
  }

  Future<void> _loadCourseSections() async {
    try {
      print('\n=== شروع بارگذاری سکشن‌ها از کش ===');
      final data = await widget.hiveService.getAllData();
      print('محتویات کلیدهای موجود در کش: ${data.keys.toList()}');

      final courseMap = data['course_map'] as Map<String, dynamic>?;
      if (courseMap == null) {
        print('course_map در کش یافت نشد');
        return;
      }

      print('تعداد دروس موجود در course_map: ${courseMap.length}');
      print('شناسه‌های دروس انتخاب شده: ${widget.selectedCourseIds}');

      List<Map<String, dynamic>> loadedSections = [];

      for (final courseId in widget.selectedCourseIds) {
        print('\nدر حال بررسی درس با شناسه: $courseId');

        final coursesWithId = courseMap.entries.where((entry) {
          final course = entry.value['course'] as Map<String, dynamic>?;
          return course?['id'] == courseId;
        }).toList();

        if (coursesWithId.isEmpty) {
          print('درس با شناسه $courseId در کش یافت نشد');
          continue;
        }

        final courseData = coursesWithId.first.value;
        final course = courseData['course'] as Map<String, dynamic>;
        final sections = courseData['sections'] as List? ?? [];

        print('نام درس: ${course['name']}');
        print('تعداد سکشن‌ها: ${sections.length}');

        for (final section in sections) {
          if (section is Map<String, dynamic>) {
            print('اطلاعات سکشن: $section');
            loadedSections.add({
              ...section,
              'course_name':
                  course['name'] ?? course['course_name'] ?? 'درس ناشناخته',
              'course_id': courseId,
            });
          }
        }
      }

      print('\n=== نتیجه نهایی ===');
      print('تعداد کل سکشن‌های بارگذاری شده: ${loadedSections.length}');

      setState(() {
        sections = loadedSections;
      });
    } catch (e, stackTrace) {
      print('خطا در بارگذاری سکشن‌ها:');
      print('پیام خطا: $e');
      print('جزئیات خطا: $stackTrace');
    }
  }

  Widget _buildTimeCell(BuildContext context, int hour) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: darkMode.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: Text(
        '$hour:00',
        style: TextStyle(
          color: darkMode.isDarkMode ? AppColors.darkText : AppColors.black,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String day) {
    return Container(
      decoration: BoxDecoration(
        color: darkMode.isDarkMode
            ? AppColors.darkCardBackground
            : AppColors.blueShade100,
        border: Border.all(
          color: darkMode.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      alignment: Alignment.center,
      child: Text(
        day,
        style: TextStyle(
          color: darkMode.isDarkMode ? AppColors.darkText : AppColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimeSlotCell(int hour, int dayIndex) {
    final sectionForSlot = sections.where((section) {
      final sectionDay = section['day'] as int? ?? -1;
      final startTime = section['start_time'] as int? ?? -1;
      final endTime = section['end_time'] as int? ?? -1;

      return sectionDay == dayIndex && startTime <= hour && endTime > hour;
    }).toList();

    if (sectionForSlot.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: darkMode.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
      );
    }

    final section = sectionForSlot.first;
    final startTime = section['start_time'] as int? ?? hour;
    final endTime = section['end_time'] as int? ?? (hour + 1);
    final isStart = startTime == hour;

    if (!isStart) return const SizedBox();

    return Container(
      height: (endTime - startTime) * 60.0,
      decoration: BoxDecoration(
        color: darkMode.isDarkMode ? AppColors.darkAccent : AppColors.blue,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            section['course_name'] as String? ?? 'درس ناشناخته',
            style: TextStyle(
              color: darkMode.isDarkMode ? AppColors.darkText : AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'گروه ${section['section_number'] ?? '?'}',
            style: TextStyle(
              color: darkMode.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.white.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${section['location'] ?? 'نامشخص'}',
            style: TextStyle(
              color: darkMode.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.white.withOpacity(0.8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: darkMode.isDarkMode
            ? AppColors.darkAppBarBackground
            : AppColors.indigo,
        title: const Text(
          'برنامه زمانی دروس',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          DarkModeToggle(controller: darkMode),
        ],
      ),
      body: Container(
        color: isDarkMode ? AppColors.darkBackground : AppColors.blueShade50,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    // Empty corner cell
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                        color: darkMode.isDarkMode
                            ? AppColors.darkCardBackground
                            : AppColors.blueShade100,
                        border: Border.all(
                          color: darkMode.isDarkMode
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                        ),
                      ),
                    ),
                    // Day headers
                    ...days.map((day) => SizedBox(
                          width: 120,
                          child: _buildHeaderCell(day),
                        )),
                  ],
                ),
                // Time slots
                ...hours.map((hour) => Row(
                      children: [
                        // Time cell
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: _buildTimeCell(context, hour),
                        ),
                        // Day cells
                        ...List.generate(
                          days.length,
                          (dayIndex) => SizedBox(
                            width: 120,
                            height: 60,
                            child: _buildTimeSlotCell(hour, dayIndex),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
