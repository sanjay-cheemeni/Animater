import 'package:animater/screen/basic-animations/animated_align_demo.dart';
import 'package:animater/screen/basic-animations/animated_container_demo.dart';
import 'package:animater/screen/basic-animations/animated_opacity_demo.dart';
import 'package:animater/screen/basic-animations/animated_switcher_demo.dart';
import 'package:animater/screen/basic-animations/explicit_spinner_demo.dart';
import 'package:animater/screen/basic-animations/scale_rotate_demo.dart';
import 'package:animater/screen/basic-animations/tween_builder_demo.dart';
import 'package:flutter/material.dart';

class BasicAnimationPage extends StatefulWidget {
  const BasicAnimationPage({super.key});

  @override
  State<BasicAnimationPage> createState() => _BasicAnimationPageState();
}

class _BasicAnimationPageState extends State<BasicAnimationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: Text('Basic Animations', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 65, 3),
        automaticallyImplyLeading: false,
      ),
      body:  ListView(
        children: [
          AnimatedContainerDemo(),
          AnimatedOpacityDemo(),
          AnimatedAlignDemo(),
          ScaleRotateDemo(),
          TweenBuilderDemo(),
          AnimatedSwitcherDemo(),
          ExplicitSpinnerDemo(),
        ],
      ),
    );
  }
}
