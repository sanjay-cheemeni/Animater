import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class StaggeredDemo extends StatefulWidget {
  const StaggeredDemo({super.key});

  @override
  State<StaggeredDemo> createState() => _StaggeredDemoState();
}

class _StaggeredDemoState extends State<StaggeredDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  late final Animation<double> _opacity;
  late final Animation<double> _size;
  late final Animation<BorderRadius?> _radius;
  late final Animation<Color?> _color;

  // Helper: attach a tween to one slice (begin..end) of the controller's 0..1.
  Animation<T> _step<T>(Tween<T> tween, double begin, double end, Curve curve) {
    return tween.animate(
      CurvedAnimation(
        parent: _c,
        curve: Interval(begin, end, curve: curve),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    //  timeline (0.0 ------------------------------------ 1.0)
    //  opacity  [0.00 - 0.25]
    //  size              [0.25 - 0.55]
    //  radius                       [0.55 - 0.75]
    //  color                                   [0.75 - 1.00]
    _opacity = _step(Tween<double>(begin: 0, end: 1), 0.00, 0.25, Curves.easeIn);
    _size = _step(Tween<double>(begin: 40, end: 120), 0.25, 0.55, Curves.easeOutBack);
    _radius = _step(
      BorderRadiusTween(
        begin: BorderRadius.circular(4),
        end: BorderRadius.circular(60),
      ),
      0.55,
      0.75,
      Curves.easeInOut,
    );
    _color = _step(
      ColorTween(begin: Colors.indigo, end: Colors.amber),
      0.75,
      1.00,
      Curves.linear,
    );

    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '5. Staggered animation',
      description: 'Fade, then grow, then round, then recolor, in sequence.',
      height: 210,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 120,
            child: Center(
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, _) {
                  return Opacity(
                    opacity: _opacity.value,
                    child: Container(
                      width: _size.value,
                      height: _size.value,
                      decoration: BoxDecoration(
                        color: _color.value,
                        borderRadius: _radius.value,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _c.forward(from: 0),
            child: const Text('Replay'),
          ),
        ],
      ),
    );
  }
}