import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppBarCopy extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCopy({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        SlideEffect(
          begin: Offset(0, -1),
          end: Offset(0, 0),
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOut,
        ),
        FadeEffect(
          begin: 0.0,
          end: 1.0,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOut,
        ),
      ],
      child: AppBar(
        toolbarHeight: 100,
        title: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    const SizedBox(width: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double nameFontSize =
                            constraints.maxWidth < 600 ? 14 : 16;
                        final double specializationFontSize =
                            constraints.maxWidth < 600 ? 12 : 14;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sina NejadHosseini',
                              style: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Programmer',
                              style: TextStyle(
                                fontSize: specializationFontSize,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                Animate(
                  effects: const [
                    ShakeEffect(duration: Duration(milliseconds: 1000), hz: 2),
                  ],
                  onPlay: (controller) => controller.repeat(),
                  child: Transform.rotate(
                    angle: 2.4,
                    child: IconButton(
                      icon: const Icon(Icons.phone, color: Colors.green),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => _buildContactSheet(context),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.95),
        shadowColor: Colors.deepPurpleAccent,
        elevation: 12,
      ),
    );
  }

  Widget _buildContactSheet(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _contactRow('Contact Me:', null),
          const SizedBox(height: 8),
          _contactRow(
            'sina.nejadhoseini@gmail.com',
            Icons.email,
            'mailto:sina.nejadhoseini@gmail.com',
            Colors.red,
          ),
          const SizedBox(height: 8),
          _contactRow(
            '+989167991896',
            Icons.phone,
            'tel:+989167991896',
            Colors.green,
          ),
          const SizedBox(height: 8),
          _contactRow(
            'Telegram',
            Icons.telegram,
            'https://t.me/isina_nej',
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _contactRow(
            'LinkedIn',
            Icons.link,
            'https://www.linkedin.com/in/sina-nejadhoseini-872b4431a',
            Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _contactRow(
    String text,
    IconData? icon, [
    String? link,
    Color? color,
  ]) {
    return Row(
      children: [
        if (icon != null) Icon(icon, color: color),
        if (icon != null) const SizedBox(width: 8),
        Flexible(
          child: InkWell(
            onTap: link != null ? () => _launchUrl(link) : null,
            child: Text(
              text,
              style: TextStyle(
                color: color ?? Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
