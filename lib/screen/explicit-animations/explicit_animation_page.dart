import 'package:animater/screen/explicit-animations/animated_widget_demo.dart';
import 'package:animater/screen/explicit-animations/controller_basics_demo.dart';
import 'package:animater/screen/explicit-animations/multi_tween_demo.dart';
import 'package:animater/screen/explicit-animations/staggered_demo.dart';
import 'package:animater/screen/explicit-animations/staggered_list_demo.dart';
import 'package:animater/screen/explicit-animations/status_listener_demo.dart';
import 'package:animater/screen/explicit-animations/transitions_demo.dart';
import 'package:flutter/material.dart';

class ExplicitAnimationPage extends StatelessWidget {
  const ExplicitAnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 227, 227),
      appBar: AppBar(
        title: Text('Explicit Animations', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 65, 3),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          ControllerBasicsDemo(),
          TransitionsDemo(),
          MultiTweenDemo(),
          StatusListenerDemo(),
          StaggeredDemo(),
          StaggeredListDemo(),
          AnimatedWidgetDemo(),
        ],
      ),
    );
  }
}
