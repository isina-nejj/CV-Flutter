import 'package:flutter/material.dart';
import '../../widgets/animated_menu_button.dart';
import '../../../core/style/sizes.dart';
import '../../../core/style/text_styles.dart';
import '../../../core/theme/dark_mode_controller.dart';
import '../course/course_page.dart';
import '../schedule/schedule_page.dart';
// import '../grades/grades_page.dart';
import '../khabgah/khabgah.dart';
import '../next_term/course_registration_page.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/hive_service.dart';
import '../login/login_page.dart';

class MainPage extends StatefulWidget {
  final HiveService hiveService;

  const MainPage({
    super.key,
    required this.hiveService,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _checkAndLoadData().then((_) => _debugPrintCourses());
  }

  Future<void> _debugPrintCourses() async {
    debugPrint('\n=== وضعیت داده‌های ذخیره شده در کش ===');
    try {
      final data = await widget.hiveService.getAllData();
      final courseMap = (data['course_map'] as Map?)?.length ?? 0;
      final sections = (data['sections'] as List?)?.length ?? 0;
      debugPrint('تعداد کل دروس در course_map: $courseMap');
      debugPrint('تعداد سکشن‌ها: $sections');
      debugPrint('=== پایان وضعیت داده‌ها ===\n');
    } catch (e) {
      debugPrint('خطا در نمایش اطلاعات کش: $e');
    }
  }

  Future<void> _checkAndLoadData() async {
    final lastUpdateTime = await widget.hiveService.getLastUpdateTime();
    if (lastUpdateTime == null ||
        DateTime.now().difference(lastUpdateTime).inHours >= 24) {
      await _refreshData();
    }
  }

  Future<void> _refreshData() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      // دریافت همه اطلاعات با یک درخواست
      final allData = await ApiService.getAllUniversityData();

      // ذخیره مستقیم داده‌ها در Hive
      await widget.hiveService.saveServerData(allData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('اطلاعات با موفقیت به‌روزرسانی شد'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('خطا در به‌روزرسانی اطلاعات'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Builder(
            builder: (context) => Text(
              'صفحه اصلی',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: _isRefreshing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    )
                  : const Icon(Icons.refresh),
              onPressed: _isRefreshing ? null : _refreshData,
            ),
            DarkModeToggle(controller: DarkModeController()),
          ]),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = MediaQuery.of(context).size.width > 600;
          final crossAxisCount = isWeb
              ? AppSizes.webCrossAxisCount
              : AppSizes.mobileCrossAxisCount;

          return Directionality(
            textDirection: TextDirection.rtl,
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              padding: AppSizes.pagePadding,
              mainAxisSpacing: AppSizes.gridSpacing,
              crossAxisSpacing: AppSizes.gridSpacing,
              childAspectRatio: 1.0,
              children: [
                AnimatedMenuButton(
                  title: 'انتخاب واحد',
                  style: AppTextStyles.mainPageMenuButton,
                  icon: Icons.school,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => LoginPage(),
                        builder: (context) => CourseSelectionPage(
                          hiveService: widget.hiveService,
                        ),
                      ),
                    );
                  },
                  gradientStartColor: DarkModeController()
                      .getMenuButtonStartColor('courseSelection'),
                  gradientEndColor: DarkModeController()
                      .getMenuButtonEndColor('courseSelection'),
                ),
                AnimatedMenuButton(
                  title: 'برنامه کلاسی',
                  style: AppTextStyles.mainPageMenuButton,
                  icon: Icons.calendar_today,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchedulePage(
                          hiveService: widget.hiveService,
                        ),
                      ),
                    );
                  },
                  gradientStartColor:
                      DarkModeController().getMenuButtonStartColor('schedule'),
                  gradientEndColor:
                      DarkModeController().getMenuButtonEndColor('schedule'),
                ),
                // AnimatedMenuButton(
                //   title: 'نمرات',
                //   style: AppTextStyles.mainPageMenuButton,
                //   icon: Icons.grade,
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ChartPage(
                //           hiveService: widget.hiveService,
                //         ),
                //       ),
                //     );
                //   },
                //   gradientStartColor:
                //       DarkModeController().getMenuButtonStartColor('grades'),
                //   gradientEndColor:
                //       DarkModeController().getMenuButtonEndColor('grades'),
                // ),
                AnimatedMenuButton(
                  title: 'رزرو خوابگاه',
                  style: AppTextStyles.mainPageMenuButton,
                  icon: Icons.apartment,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KhabgahPage(),
                      ),
                    );
                  },
                  gradientStartColor:
                      DarkModeController().getMenuButtonStartColor('dormitory'),
                  gradientEndColor:
                      DarkModeController().getMenuButtonEndColor('dormitory'),
                ),
                AnimatedMenuButton(
                  title: 'ثبت دروس ترم بعد',
                  style: AppTextStyles.mainPageMenuButton,
                  icon: Icons.book,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                        // builder: (context) => CourseRegistrationPage(
                        //   hiveService: widget.hiveService,
                        // ),
                      ),
                    );
                  },
                  gradientStartColor:
                      DarkModeController().getMenuButtonStartColor('nextTerm'),
                  gradientEndColor:
                      DarkModeController().getMenuButtonEndColor('nextTerm'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
