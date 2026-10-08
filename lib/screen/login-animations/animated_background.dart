import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 14))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _blob(double size, double angle, double rx, double ry, double alpha) {
    return Align(
      alignment: Alignment(rx * math.cos(angle), ry * math.sin(angle)),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child, // the login form is built once, not every frame
      builder: (context, child) {
        final a = _c.value * 2 * math.pi; // one full circle per loop

        return Stack(
          fit: StackFit.expand,
          children: [
            // Gradient whose direction slowly rotates
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(math.cos(a), math.sin(a)),
                  end: Alignment(-math.cos(a), -math.sin(a)),
                  colors: const [
                    Color(0xFF3F51B5),
                    Color(0xFF7E57C2),
                    Color(0xFFEC407A),
                  ],
                ),
              ),
            ),
            // Drifting blobs, each on its own orbit and phase
            _blob(260, a, 0.9, 0.7, 0.10),
            _blob(180, a + 2.1, 0.8, 0.9, 0.08),
            _blob(120, a + 4.2, 0.9, 0.6, 0.12),
            child!,
          ],
        );
      },
    );
  }
}