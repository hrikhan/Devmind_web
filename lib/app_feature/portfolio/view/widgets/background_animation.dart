import 'dart:math';
import 'package:flutter/material.dart';

class SkillCloud extends StatelessWidget {
  final List<String> skillUrls;

  const SkillCloud({super.key, required this.skillUrls});

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return Stack(
      children: List.generate(skillUrls.length, (index) {
        final startX = random.nextDouble() * 2 - 1; // -1..1
        final startY = random.nextDouble() * 2 - 1;
        final endX = random.nextDouble() * 2 - 1;
        final endY = random.nextDouble() * 2 - 1;

        final durationSeconds = 10 + random.nextInt(10); // 10..20 seconds

        return SkillBubble(
          size: 60 + random.nextInt(40).toDouble(), // 60..100 px
          duration: Duration(seconds: durationSeconds),
          beginAlignment: Alignment(startX, startY),
          endAlignment: Alignment(endX, endY),
          child: Image.network(skillUrls[index], fit: BoxFit.cover),
        );
      }),
    );
  }
}

class SkillBubble extends StatefulWidget {
  final double size;
  final Widget child;
  final Alignment beginAlignment;
  final Alignment endAlignment;
  final Duration duration;

  const SkillBubble({
    super.key,
    required this.size,
    required this.child,
    required this.beginAlignment,
    required this.endAlignment,
    this.duration = const Duration(seconds: 14),
  });

  @override
  State<SkillBubble> createState() => _SkillBubbleState();
}

class _SkillBubbleState extends State<SkillBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _animation = AlignmentTween(
      begin: widget.beginAlignment,
      end: widget.endAlignment,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Align(
          alignment: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.16),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.28),
                  blurRadius: widget.size * 0.5,
                  spreadRadius: widget.size * 0.2,
                ),
              ],
            ),
            child: ClipOval(child: widget.child),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
