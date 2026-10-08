import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class MultiTweenDemo extends StatefulWidget {
  const MultiTweenDemo({super.key});

  @override
  State<MultiTweenDemo> createState() => _MultiTweenDemoState();
}

class _MultiTweenDemoState extends State<MultiTweenDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _size;
  late final Animation<Color?> _color;
  late final Animation<BorderRadius?> _radius;
  late final Animation<double> _angle;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    final curved = CurvedAnimation(parent: _c, curve: Curves.easeInOutBack);

    _size = Tween<double>(begin: 80, end: 130).animate(curved);
    _color = ColorTween(begin: Colors.blue, end: Colors.pink).animate(curved);
    _radius = BorderRadiusTween(
      begin: BorderRadius.circular(8),
      end: BorderRadius.circular(65),
    ).animate(curved);
    _angle = Tween<double>(begin: 0, end: math.pi / 2).animate(curved);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toggle() {
    // Go the opposite way of whichever direction we last finished
    if (_c.status == AnimationStatus.completed ||
        _c.status == AnimationStatus.forward) {
      _c.reverse();
    } else {
      _c.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '3. Multiple tweens, one controller',
      description: 'Tap the shape. Size, color, radius and rotation sync up.',
      height: 170,
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            return Transform.rotate(
              angle: _angle.value,
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
    );
  }
}