import 'package:flutter/material.dart';
import 'skills_widget.dart';

class SkillGroup extends StatefulWidget {
  final String title;
  final List<SkillProgress> skills;

  const SkillGroup({required this.title, required this.skills, Key? key})
    : super(key: key);

  @override
  State<SkillGroup> createState() => _SkillGroupState();
}

class _SkillGroupState extends State<SkillGroup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ...widget.skills.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: AnimatedSkillBox(
                    child: entry.value,
                    fromLeft: entry.key % 2 == 0,
                    // Add delay based on index
                    delay: Duration(milliseconds: 200 * entry.key),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
