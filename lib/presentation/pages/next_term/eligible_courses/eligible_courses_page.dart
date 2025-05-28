import 'package:flutter/material.dart';
import '../../../../data/services/hive_service.dart';
import 'section_popup.dart';
import '../../../../../core/style/colors.dart';
import '../../../../../core/style/text_styles.dart';
import '../../../../../core/style/sizes.dart';
import '../../../../core/theme/dark_mode_controller.dart';

class EligibleCoursesPage extends StatefulWidget {
  final List<int> selectedCourseIds;
  final List<Map<String, dynamic>>? cachedCourses;
  final Map<int, bool>? courseSections;
  final HiveService hiveService;

  const EligibleCoursesPage({
    Key? key,
    required this.selectedCourseIds,
    this.cachedCourses,
    this.courseSections,
    required this.hiveService,
  }) : super(key: key);

  @override
  _EligibleCoursesPageState createState() => _EligibleCoursesPageState();
}

class _EligibleCoursesPageState extends State<EligibleCoursesPage> {
  List<Map<String, dynamic>>? _eligibleCourses;
  late final DarkModeController darkMode;
  String filterOption = 'all';
  bool _isLoading = true;

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeController();
    darkMode.addListener(_onThemeChanged);
    _loadCourses();
  }

  @override
  void dispose() {
    darkMode.removeListener(_onThemeChanged);
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    try {
      // استفاده از cachedCourses پاس داده شده
      final allCourses = widget.cachedCourses ?? [];
      setState(() {
        _eligibleCourses = allCourses
            .where((course) => widget.selectedCourseIds.contains(course['id']))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading course data: $e');
      setState(() {
        _eligibleCourses = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مدیریت سکشن‌های دروس انتخابی',
          style: TextStyle(
            color:
                darkMode.isDarkMode ? AppColors.darkText : AppColors.appBarText,
          ),
        ),
        backgroundColor: darkMode.isDarkMode
            ? AppColors.darkAppBarBackground
            : AppColors.appBarBackground,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_alt,
              color: filterOption == 'all'
                  ? (darkMode.isDarkMode
                      ? AppColors.filterAllDark
                      : AppColors.filterAllLight)
                  : filterOption == 'withSections'
                      ? (darkMode.isDarkMode
                          ? AppColors.filterWithSectionsDark
                          : AppColors.filterWithSectionsLight)
                      : (darkMode.isDarkMode
                          ? AppColors.filterWithoutSectionsDark
                          : AppColors.filterWithoutSectionsLight),
            ),
            onPressed: () {
              setState(() {
                if (filterOption == 'all') {
                  filterOption = 'withSections';
                } else if (filterOption == 'withSections') {
                  filterOption = 'withoutSections';
                } else {
                  filterOption = 'all';
                }
              });
            },
          ),
          DarkModeToggle(controller: darkMode),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildCoursesList(),
    );
  }

  Widget _buildCoursesList() {
    if (_eligibleCourses == null || _eligibleCourses!.isEmpty) {
      return const Center(child: Text('هیچ درسی پیدا نشد.'));
    }

    return ListView.builder(
      itemCount: _eligibleCourses!.length,
      itemBuilder: (context, index) {
        final course = _eligibleCourses![index];
        final courseId = course['id'];
        final courseName =
            course['name'] ?? course['course_name'] ?? 'درس ناشناخته';

        // Get section status from passed courseSections
        final hasSection = widget.courseSections?[courseId] ?? false;

        if ((filterOption == 'withSections' && !hasSection) ||
            (filterOption == 'withoutSections' && hasSection)) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: AppSizes.cardMargin,
          padding: AppSizes.cardPadding,
          decoration: BoxDecoration(
            color: darkMode.isDarkMode
                ? AppColors.darkCardBackground
                : AppColors.white,
            borderRadius: AppSizes.defaultRadius,
            boxShadow: [
              BoxShadow(
                color: darkMode.isDarkMode ? Colors.black26 : Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: darkMode.isDarkMode
                ? Border.all(
                    color: AppColors.darkDivider,
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                courseName,
                style: AppTextStyles.courseRegistrationTitle.copyWith(
                  color:
                      darkMode.isDarkMode ? AppColors.darkText : Colors.black87,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: darkMode.isDarkMode
                      ? AppColors.darkAccent
                      : AppColors.blue,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SectionPopup(
                      courseId: courseId,
                      courseName: courseName,
                      hiveService: widget.hiveService,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
