import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AuroraBackground extends StatefulWidget {
  /// intensity: 0.0 - 1.0 controls strength/opacity of the aurora
  final double intensity;

  const AuroraBackground({Key? key, this.intensity = 1.0}) : super(key: key);

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  ui.FragmentProgram? _program;
  ui.FragmentShader? _shader;
  late final Ticker _ticker;
  double _time = 0.0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker((elapsed) {
      // elapsed in microseconds; convert to seconds
      setState(() {
        _time = elapsed.inMilliseconds / 1000.0;
      });
    });
    _ticker.start();
  }

  Future<void> _loadShader() async {
    try {
      final program =
          await ui.FragmentProgram.fromAsset('assets/shadar/aurora.glsl');
      setState(() {
        _program = program;
        _loaded = true;
      });
    } catch (e) {
      // shader failed to load — degrade gracefully
      debugPrint('Failed to load aurora shader: $e');
    }
  }

  @override
  void dispose() {
    _ticker.stop();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _program == null) {
      // fallback: subtle gradient when shader isn't available yet
      return IgnorePointer(
        child: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B1226).withOpacity(1.0 * widget.intensity),
                  Color(0xFF10142A).withOpacity(0.8 * widget.intensity),
                  Color(0xFF1B2340).withOpacity(0.6 * widget.intensity),
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
            program: _program!,
            time: _time,
            intensity: widget.intensity,
          ),
        ),
      ),
    );
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
