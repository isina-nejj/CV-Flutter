import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileSection extends StatefulWidget {
  final String name;
  final String title;
  final String email;
  final String phone;
  final String telegram;
  final String linkedIn;

  const ProfileSection({
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.telegram,
    required this.linkedIn,
    Key? key,
  }) : super(key: key);

  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  bool _isHoveredEmail = false;
  bool _isHoveredPhone = false;
  bool _isHoveredTelegram = false;
  bool _isHoveredLinkedIn = false;

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        const SizedBox(height: 16),
        Text(
          widget.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Me:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveredEmail = true),
                    onExit: (_) => setState(() => _isHoveredEmail = false),
                    child: GestureDetector(
                      onTap: () => _launchUrl('mailto:${widget.email}'),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email,
                            color:
                                _isHoveredEmail ? Colors.red : Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Email',
                            style: TextStyle(
                              color:
                                  _isHoveredEmail ? Colors.red : Colors.white70,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveredPhone = true),
                    onExit: (_) => setState(() => _isHoveredPhone = false),
                    child: GestureDetector(
                      onTap: () => _launchUrl('tel:${widget.phone}'),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color:
                                _isHoveredPhone ? Colors.green : Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Phone',
                            style: TextStyle(
                              color:
                                  _isHoveredPhone
                                      ? Colors.green
                                      : Colors.white70,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveredTelegram = true),
                    onExit: (_) => setState(() => _isHoveredTelegram = false),
                    child: GestureDetector(
                      onTap:
                          () => _launchUrl('https://t.me/${widget.telegram}'),
                      child: Row(
                        children: [
                          Icon(
                            Icons.telegram,
                            color:
                                _isHoveredTelegram
                                    ? Colors.blue
                                    : Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Telegram',
                            style: TextStyle(
                              color:
                                  _isHoveredTelegram
                                      ? Colors.blue
                                      : Colors.white70,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHoveredLinkedIn = true),
                    onExit: (_) => setState(() => _isHoveredLinkedIn = false),
                    child: GestureDetector(
                      onTap: () => _launchUrl('https://${widget.linkedIn}'),
                      child: Row(
                        children: [
                          Icon(
                            Icons.link,
                            color:
                                _isHoveredLinkedIn
                                    ? Colors.blueAccent
                                    : Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'LinkedIn',
                            style: TextStyle(
                              color:
                                  _isHoveredLinkedIn
                                      ? Colors.blueAccent
                                      : Colors.white70,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .scale(
              begin: const Offset(0.6, 0.6),
              end: const Offset(1.0, 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
            )
            .fade(
              begin: 0.0,
              end: 1.0,
              duration: const Duration(milliseconds: 800),
            ),
      ],
    );
  }
}
