import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class TweenBuilderDemo extends StatefulWidget {
  const TweenBuilderDemo({super.key});

  @override
  State<TweenBuilderDemo> createState() => _TweenBuilderDemoState();
}

class _TweenBuilderDemoState extends State<TweenBuilderDemo> {
  int replayCount = 0;

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '5. TweenAnimationBuilder',
      description: 'Animates a value from 0 to 1 and uses it for fade + slide.',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            // changing the key rebuilds the widget, so the animation replays
            key: ValueKey(replayCount),
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 1),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 40 * (1 - value)), // starts 40px lower
                  child: child,
                ),
              );
            },
            child: const Text(
              'Hello!',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() => replayCount++),
            child: const Text('Replay'),
          ),
        ],
      ),
    );
  }
}