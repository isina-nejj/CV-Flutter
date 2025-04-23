import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/appbar.dart';
import 'widgets/profile_section.dart';
import './widgets/skills_constants.dart';
import './widgets/skills_widget.dart';
import './widgets/skill_group.dart';
import './widgets/contact_box.dart';
import './widgets/section_title.dart';

class CurvedScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return Transform(
      transform:
          Matrix4.identity()
            ..setEntry(3, 2, 1) // This adds perspective
            ..rotateX(0.01), // This adds a slight tilt
      alignment: Alignment.center,
      child: child,
    );
  }
}

void main() => runApp(MyApp());

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    required this.mobile,
    required this.tablet,
    required this.desktop,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobile;
        } else if (constraints.maxWidth < 900) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildThemeData(),
      home: ResponsiveLayout(
        mobile: const ResumePage(),
        tablet: const ResumePage(),
        desktop: const DesktopResumePage(),
      ),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black.withOpacity(0.9),
        elevation: 4,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
        bodyMedium: GoogleFonts.roboto(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const ResponsiveText({
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double scaleFactor = constraints.maxWidth / 400;
        return Text(
          text,
          style: TextStyle(
            fontSize: fontSize * scaleFactor,
            fontWeight: fontWeight,
            color: color,
          ),
        );
      },
    );
  }
}

// Update ResumePage to use the SkillsWidget
class ResumePage extends StatelessWidget {
  const ResumePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarCopy(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: CurvedScrollBehavior(),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionTitle(title: 'About Me'),
                              const ContactBox(),
                              SectionTitle(title: 'Skills'),
                              SkillsWidget(skills: skills),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

// Update DesktopResumePage to use the SkillsWidget
class DesktopResumePage extends StatefulWidget {
  const DesktopResumePage({Key? key}) : super(key: key);

  @override
  State<DesktopResumePage> createState() => _DesktopResumePageState();
}

class _DesktopResumePageState extends State<DesktopResumePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start the animation when the widget is built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 4,
            color: Colors.grey[900],
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: CurvedScrollBehavior(),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  ProfileSection(
                                    name: 'Sina NejadHosseini',
                                    title: 'Programmer & Network Specialist',
                                    email: 'sina.nejadhoseini@gmail.com',
                                    phone: '+09167991896',
                                    telegram: 't.me/isina_nej',
                                    linkedIn:
                                        'https://www.linkedin.com/in/sina-nejadhoseini-872b4431a',
                                  ),
                                  SizedBox(height: 16),
                                  const ContactBox(),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: ScrollConfiguration(
                behavior: CurvedScrollBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SkillsWidget(skills: skills),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  final List<Map<String, dynamic>> skills;

  const SkillsSection({required this.skills, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          skills.map((skillGroup) {
            return SkillGroup(
              title: skillGroup['title'],
              skills: skillGroup['skills'],
            );
          }).toList(),
    );
  }
}
