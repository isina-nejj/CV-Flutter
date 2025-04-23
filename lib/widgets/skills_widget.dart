import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'skill_group.dart';

class SkillsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> skills;

  const SkillsWidget({required this.skills, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          skills.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AnimatedSkillBox(
                child: SkillGroup(
                  title: entry.value['title'],
                  skills: entry.value['skills'],
                ),
                fromLeft: entry.key % 2 == 0,
                delay: Duration(milliseconds: 300 * entry.key),
              ),
            );
          }).toList(),
    );
  }
}

class SkillProgress extends StatefulWidget {
  final String skill;
  final double percentage;
  final IconData icon;
  final Color iconColor;
  final String aboutMeDescription;

  const SkillProgress({
    required this.skill,
    required this.percentage,
    required this.icon,
    required this.iconColor,
    required this.aboutMeDescription,
    Key? key,
  }) : super(key: key);

  @override
  _SkillProgressState createState() => _SkillProgressState();
}

class _SkillProgressState extends State<SkillProgress>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  late final Animation<double> _animation = Tween<double>(
    begin: 0,
    end: widget.percentage,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

  late final AnimationController _fadeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _fadeController,
    curve: Curves.easeIn,
  );

  late final AnimationController _hoverController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300), // تنظیم به 0.3 ثانیه
  );

  late final Animation<double> _hoverAnimation = CurvedAnimation(
    parent: _hoverController,
    curve: Curves.easeInOut, // تغییر به easeInOut برای نرم‌تر شدن
  );

  @override
  void dispose() {
    _controller.dispose();
    _hoverController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.skill),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1) {
          _controller.forward();
          _fadeController.forward();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text(widget.skill),
                    content: Text(widget.aboutMeDescription),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
            );
          },
          child: MouseRegion(
            onEnter: (_) => _hoverController.forward(),
            onExit: (_) => _hoverController.reverse(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(widget.icon, color: widget.iconColor),
                    const SizedBox(width: 8),
                    Text(
                      widget.skill,
                      style: const TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                SizeTransition(
                  sizeFactor: _hoverAnimation,
                  axisAlignment: -1.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.aboutMeDescription,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _animation.value,
                      color: widget.iconColor,
                      backgroundColor: Colors.grey[700],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedSkillBox extends StatefulWidget {
  final Widget child;
  final bool fromLeft;
  final Duration delay;

  const AnimatedSkillBox({
    required this.child,
    required this.fromLeft,
    this.delay = Duration.zero,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedSkillBoxState createState() => _AnimatedSkillBoxState();
}

class _AnimatedSkillBoxState extends State<AnimatedSkillBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.fromLeft ? const Offset(-1, 0) : const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    if (widget.delay == Duration.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
    } else {
      Future.delayed(widget.delay, _startAnimation);
    }
  }

  void _startAnimation() {
    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.child.hashCode.toString()),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.1 && !_controller.isAnimating) {
          Future.delayed(widget.delay, _startAnimation);
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(position: _slideAnimation, child: widget.child),
      ),
    );
  }
}
