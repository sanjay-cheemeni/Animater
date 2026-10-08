import 'package:flutter/material.dart';
import '../widgets/demo_card.dart';

class StatusListenerDemo extends StatefulWidget {
  const StatusListenerDemo({super.key});

  @override
  State<StatusListenerDemo> createState() => _StatusListenerDemoState();
}

class _StatusListenerDemoState extends State<StatusListenerDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _scale;

  int _beats = 0;
  bool _running = false;
  AnimationStatus _status = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scale = Tween<double>(begin: 1.0, end: 1.5)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));

    _c.addStatusListener((status) {
      if (!mounted) return;
      setState(() => _status = status);

      if (!_running) return;

      if (status == AnimationStatus.completed) {
        _c.reverse(); // reached the top, go back down
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _beats++); // one full beat finished
        _c.forward(); // and go again
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _running = !_running);
    if (_running) {
      _c.forward();
    }
    // when _running is false, the listener stops restarting it
  }

  @override
  Widget build(BuildContext context) {
    return DemoCard(
      title: '4. Status listeners',
      description: 'A heartbeat built by reacting to completed / dismissed.',
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scale,
            child: const Icon(Icons.favorite, color: Colors.red, size: 60),
          ),
          const SizedBox(height: 16),
          Text('status: ${_status.name}   beats: $_beats'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _toggle,
            child: Text(_running ? 'Stop' : 'Start'),
          ),
        ],
      ),
    );
  }
}