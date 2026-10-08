import 'package:flutter/material.dart';

enum SubmitState { idle, loading, success }

class LoadingButton extends StatefulWidget {
  final String label;
  final SubmitState state;
  final VoidCallback onPressed;

  const LoadingButton({
    super.key,
    required this.label,
    required this.state,
    required this.onPressed,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final idle = widget.state == SubmitState.idle;
    final success = widget.state == SubmitState.success;

    return LayoutBuilder(
      builder: (context, box) {
        return Center(
          child: GestureDetector(
            onTapDown: idle ? (_) => setState(() => _pressed = true) : null,
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: idle ? widget.onPressed : null,
            // Press feedback: shrinks slightly while held
            child: AnimatedScale(
              scale: _pressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 120),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                // Full width when idle, a 56px circle otherwise.
                // (AnimatedContainer can't animate to double.infinity,
                //  so we read the real width from LayoutBuilder.)
                width: idle ? box.maxWidth : 56,
                height: 56,
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: success ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(idle ? 16 : 28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: switch (widget.state) {
                    SubmitState.idle => Text(
                        widget.label,
                        key: ValueKey('idle-${widget.label}'),
                        softWrap: false,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SubmitState.loading => const SizedBox(
                        key: ValueKey('loading'),
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    SubmitState.success => const Icon(
                        Icons.check,
                        key: ValueKey('success'),
                        color: Colors.white,
                        size: 30,
                      ),
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}