import 'package:flutter/material.dart';

class Like extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  const Like({
    super.key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    required this.onEnd,
    this.smallLike = false,
  });

  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration.inMilliseconds ~/ 2,
      ),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(animationController);
  }

  @override
  void didUpdateWidget(covariant Like oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await animationController.forward();
      await animationController.reverse();
      await Future.delayed(
        const Duration(
          milliseconds: 200,
        ),
      );

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
