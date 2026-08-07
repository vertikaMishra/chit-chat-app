import 'package:flutter/material.dart';

class EmojiFullScreenAnimation extends StatefulWidget {
  const EmojiFullScreenAnimation({
    super.key,
    required this.emoji,
    required this.onFinished,
  });

  final String emoji;
  final VoidCallback onFinished;

  @override
  State<EmojiFullScreenAnimation> createState() =>
      _EmojiFullScreenAnimationState();
}

class _EmojiFullScreenAnimationState extends State<EmojiFullScreenAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Total animation time = 750 milliseconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    // Emoji grows and then disappears
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.3,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.25,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.25,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_controller);

    // Emoji appears quickly and disappears smoothly
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 65),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    // Start animation
    _controller.forward().whenComplete(() {
      if (mounted) {
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Text(widget.emoji, style: const TextStyle(fontSize: 120)),
          ),
        ),
      ),
    );
  }
}
