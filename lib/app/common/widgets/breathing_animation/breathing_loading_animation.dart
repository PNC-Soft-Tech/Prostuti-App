import 'package:flutter/material.dart';

class BreathLoadingAnimation extends StatefulWidget {
  const BreathLoadingAnimation({
    super.key,
  });

  @override
  State<BreathLoadingAnimation> createState() => _BreathLoadingAnimationState();
}

class _BreathLoadingAnimationState extends State<BreathLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _breathAnimation;
//  String logoPath ="assets/icons/icon.jpg";
  String logoPath = "assets/logo/Logo-no-bg.png";
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _breathAnimation,
        child: Image.asset(
          logoPath,
          width: 100, // Adjust as needed
          height: 100,
        ),
      ),
    );
  }
}
