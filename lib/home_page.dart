import 'package:animater/screen/basic-animations/basic_animation_page.dart';
import 'package:animater/screen/custom-painter/custom_painter_screen.dart';
import 'package:animater/screen/explicit-animations/explicit_animation_page.dart';
import 'package:animater/screen/list-animations/expand_list_screen.dart';
import 'package:animater/screen/login-animations/login_page.dart';
import 'package:flutter/material.dart';
import 'package:oc_liquid_glass/oc_liquid_glass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track the top-left position of the movable glass panel
  Offset _position = const Offset(50, 100);

  @override
  void initState() {
    super.initState();
    OCLiquidGlassGroup.precacheShader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animations', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 65, 3),
      ),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        padding: EdgeInsets.all(10),
        children: [
          ListItem(title: 'Basic\nAnimation', screen: BasicAnimationPage()),
          ListItem(
            title: 'Explicit\nAnimations',
            screen: ExplicitAnimationPage(),
          ),
          ListItem(title: 'Login\nAnimations', screen: LoginPage()),

          ListItem(title: 'List\nAnimations', screen: ExpandListScreen()),
          ListItem(title: 'Custom\nPainter', screen: CustomPainterScreen()),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.title, required this.screen});
  final String title;
  final Widget screen;

  openPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openPage(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),

        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: EdgeInsets.all(5),

        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(Icons.start),
            Text('$title', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
