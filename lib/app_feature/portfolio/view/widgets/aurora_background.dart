import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class AuroraBackground extends StatelessWidget {
  /// intensity: 0.0 - 1.0 controls strength/opacity of the aurora
  final double intensity;

  const AuroraBackground({Key? key, this.intensity = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_AuroraBackgroundController>(
      tag: 'aurora-background-$intensity',
      global: false,
      init: _AuroraBackgroundController(intensity),
      builder: (controller) {
        return Obx(() {
          if (!controller.isReady) {
            // fallback: subtle gradient when shader isn't available yet
            return IgnorePointer(
              child: SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0B1226)
                            .withOpacity(1.0 * controller.intensity),
                        const Color(0xFF10142A)
                            .withOpacity(0.8 * controller.intensity),
                        const Color(0xFF1B2340)
                            .withOpacity(0.6 * controller.intensity),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return IgnorePointer(
            child: SizedBox.expand(
              child: CustomPaint(
                painter: _AuroraPainter(
                  program: controller.program!,
                  time: controller.time.value,
                  intensity: controller.intensity,
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class _AuroraBackgroundController extends GetxController
    with GetSingleTickerProviderStateMixin {
  _AuroraBackgroundController(this.intensity);

  final double intensity;
  ui.FragmentProgram? program;
  late final Ticker _ticker;
  final RxDouble time = 0.0.obs;
  final RxBool _loaded = false.obs;

  bool get isReady => _loaded.value && program != null;

  @override
  void onInit() {
    super.onInit();
    _loadShader();
    _ticker = createTicker((elapsed) {
      // elapsed in microseconds; convert to seconds
      time.value = elapsed.inMilliseconds / 1000.0;
    });
    _ticker.start();
  }

  Future<void> _loadShader() async {
    try {
      final programFromAsset =
          await ui.FragmentProgram.fromAsset('assets/shadar/aurora.frag');
      program = programFromAsset;
      _loaded.value = true;
    } catch (e) {
      // shader failed to load — degrade gracefully
      debugPrint('Failed to load aurora shader: $e');
    }
  }

  @override
  void onClose() {
    _ticker.stop();
    _ticker.dispose();
    super.onClose();
  }
}

class _AuroraPainter extends CustomPainter {
  final ui.FragmentProgram program;
  final double time;
  final double intensity;

  _AuroraPainter({
    required this.program,
    required this.time,
    required this.intensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // create a shader for this frame
    final shader = program.fragmentShader();

    // set uniforms in the same order the shader expects
    // (u_resolution.x, u_resolution.y, u_time)
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time * 1.0); // time in seconds

    final paint = Paint()..shader = shader;

    // draw full-bleed rect with shader applied
    canvas.drawRect(Offset.zero & size, paint);

    if (intensity < 0.999) {
      // apply a fade/overlay to lower intensity (by painting a translucent black)
      canvas.drawRect(
        Offset.zero & size,
        Paint()..color = Colors.black.withOpacity(1.0 - intensity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter old) {
    return old.time != time ||
        old.intensity != intensity ||
        old.program != program;
  }
}
