import 'package:flutter/material.dart';

const double kCardRadius = 20;

const String kLorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim '
    'veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea '
    'commodo consequat.\n\n'
    'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum '
    'dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non '
    'proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n'
    'Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam '
    'varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus '
    'magna felis sollicitudin mauris. Integer in mauris eu nibh euismod '
    'gravida. Duis ac tellus et risus vulputate vehicula.';

/// The colored rounded background that flies between list and detail.
Widget heroBackground(Color color, double radius) {
  return Material(
    color: color,
    borderRadius: BorderRadius.circular(radius),
  );
}

/// While flying, the corner radius shrinks from card (20) to screen (0).
/// `animation.value` goes 0 -> 1 on open and 1 -> 0 on close,
/// so the same formula works in both directions.
Widget heroShuttle(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection direction,
  BuildContext fromContext,
  BuildContext toContext,
  Color color,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, _) =>
        heroBackground(color, kCardRadius * (1 - animation.value)),
  );
}

class ExpandDetailPage extends StatefulWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const ExpandDetailPage({
    super.key,
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  State<ExpandDetailPage> createState() => _ExpandDetailPageState();
}

class _ExpandDetailPageState extends State<ExpandDetailPage> {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    // Let the card finish growing, then fade the content in
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  Future<void> _close() async {
    // Fade the content out first, then collapse the card back into the list
    setState(() => _showContent = false);
    await Future.delayed(const Duration(milliseconds: 150));
    if (mounted) Navigator.of(context).pop();
  }

  onbackPressed(status){

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
     onPopInvoked: onbackPressed,
      child: Scaffold(
        
        backgroundColor: Colors.transparent, // the Hero background shows through
        body: Stack(
          children: [
            // 1. Background (flies from the card)
            Positioned.fill(
              child: Hero(
                tag: 'card-bg-${widget.index}',
                flightShuttleBuilder: (a, b, c, d, e) =>
                    heroShuttle(a, b, c, d, e, widget.color),
                child: heroBackground(widget.color, 0),
              ),
            ),
      
            // 2. Content fades and slides in on top
            SafeArea(
              child: AnimatedOpacity(
                opacity: _showContent ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: AnimatedSlide(
                  offset: _showContent ? Offset.zero : const Offset(0, 0.04),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: IconButton.filledTonal(
                            
                            color:  Colors.black,
                            onPressed: _close,
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(widget.icon, color: Colors.white, size: 64),
                              const SizedBox(height: 20),
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.subtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                kLorem,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}