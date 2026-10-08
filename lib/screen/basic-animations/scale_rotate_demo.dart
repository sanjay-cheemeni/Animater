import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class ScaleRotateDemo extends StatefulWidget {
  const ScaleRotateDemo({super.key});

  @override
  State<ScaleRotateDemo> createState() => _ScaleRotateDemoState();
}

class _ScaleRotateDemoState extends State<ScaleRotateDemo> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '4. AnimatedScale + AnimatedRotation',
      description: 'Tap the heart. It grows and spins half a turn.',
      child: GestureDetector(
        onTap: () => setState(() => active = !active),
        child: AnimatedRotation(
          turns: active ? 0.5 : 0, // 0.5 turns = 180 degrees
          duration: const Duration(milliseconds: 500),
          child: AnimatedScale(
            scale: active ? 1.6 : 1.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            child: Icon(
              Icons.favorite,
              size: 60,
              color: active ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}