import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SkillCloud extends StatelessWidget {
  SkillCloud({super.key, required this.skillUrls})
    : _bubbles = _generateConfigs(skillUrls);

  final List<String> skillUrls;
  final List<_SkillBubbleConfig> _bubbles;

  static List<_SkillBubbleConfig> _generateConfigs(List<String> urls) {
    final List<_SkillBubbleConfig> configs = [];
    final List<Alignment> usedAlignments = [];

    Alignment _nextPlacement(Random random, double minDistance) {
      Alignment candidate = Alignment.center;
      int attempts = 0;
      bool _tooClose(Alignment a) {
        return usedAlignments.any((other) {
          final dx = a.x - other.x;
          final dy = a.y - other.y;
          return (dx * dx + dy * dy) < (minDistance * minDistance);
        });
      }

      while (attempts < 10) {
        candidate = Alignment(
          // widen horizontal spread a bit beyond screen bounds
          random.nextDouble() * 2.2 - 1.1,
          _nextY(random),
        );
        if (!_tooClose(candidate)) break;
        attempts++;
      }

      usedAlignments.add(candidate);
      return candidate;
    }

    for (var index = 0; index < urls.length; index++) {
      // deterministic seed per item to avoid regenerating random positions
      final random = Random(urls[index].hashCode ^ urls.length ^ index);
      final size = 60 + random.nextInt(40).toDouble(); // 60..100 px
      final durationSeconds = 10 + random.nextInt(10); // 10..20 seconds
      final minDistance = 0.22 + (size / 800); // keep bubbles from colliding

      final beginAlignment = _nextPlacement(random, minDistance);
      final endAlignment = _nextPlacement(random, minDistance);

      configs.add(_SkillBubbleConfig(
        size: size,
        duration: Duration(seconds: durationSeconds),
        beginAlignment: beginAlignment,
        endAlignment: endAlignment,
        imageUrl: urls[index],
      ));
    }

    return configs;
  }

  static double _nextY(Random random) {
    final bias = random.nextDouble();
    if (bias < 0.7) {
      return random.nextDouble() * 0.7 + 0.1; // prefer lower/middle
    }
    return random.nextDouble() * 2 - 1; // allow occasional top
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _bubbles.asMap().entries.map((entry) {
        final index = entry.key;
        final config = entry.value;

        return SkillBubble(
          key: ValueKey('skill-bubble-$index'),
          tag: 'skill-bubble-$index',
          config: config,
        );
      }).toList(),
    );
  }
}

class SkillBubble extends StatelessWidget {
  const SkillBubble({super.key, required this.config, required this.tag});

  final _SkillBubbleConfig config;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_SkillBubbleController>(
      tag: tag,
      global: false,
      init: _SkillBubbleController(config),
      builder: (controller) {
        return AnimatedBuilder(
          animation: controller.animation,
          builder: (_, __) {
            final alignment = controller.animation.value;
            return Align(
              alignment: alignment,
              child: RepaintBoundary(
                child: Container(
                  width: config.size,
                  height: config.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.16),
                        blurRadius: config.size * 0.5,
                        spreadRadius: config.size * 0.2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _SkillImage(imageUrl: config.imageUrl),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SkillBubbleController extends GetxController
    with GetSingleTickerProviderStateMixin {
  _SkillBubbleController(this._config);

  final _SkillBubbleConfig _config;
  late final AnimationController _controller;
  late final Animation<Alignment> animation;

  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(vsync: this, duration: _config.duration)
      ..repeat(reverse: true);

    animation = AlignmentTween(
      begin: _config.beginAlignment,
      end: _config.endAlignment,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }
}

class _SkillBubbleConfig {
  const _SkillBubbleConfig({
    required this.size,
    required this.beginAlignment,
    required this.endAlignment,
    required this.duration,
    required this.imageUrl,
  });

  final double size;
  final Alignment beginAlignment;
  final Alignment endAlignment;
  final Duration duration;
  final String imageUrl;
}

class _SkillImage extends StatelessWidget {
  const _SkillImage({required this.imageUrl});

  final String imageUrl;

  bool get _isSvg =>
      imageUrl.toLowerCase().contains('.svg') ||
      imageUrl.toLowerCase().contains('image/svg+xml');

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return SvgPicture.network(
        imageUrl,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => const ColoredBox(color: Colors.transparent),
      );
    }

    return Opacity(
      opacity: 0.5,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const ColoredBox(color: Colors.transparent),
      ),
    );
  }
}
