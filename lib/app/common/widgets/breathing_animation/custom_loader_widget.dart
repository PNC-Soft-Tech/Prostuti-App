import 'package:flutter/material.dart';

class CustomLoaderWidget extends StatefulWidget {
  const CustomLoaderWidget({
    super.key,
  });

  @override
  State<CustomLoaderWidget> createState() => _CustomLoaderWidgetState();
}

class _CustomLoaderWidgetState extends State<CustomLoaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _breathAnimation;
  String logoPath = "assets/logo/Logo-no-bg.png";
  double size = 120.0;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Center(
          child: ScaleTransition(
            scale: _breathAnimation,
            child: Image.asset(
              logoPath,
              width: size,
              height: size,
            ),
          ),
        ),
      ],
    );
  }
}
