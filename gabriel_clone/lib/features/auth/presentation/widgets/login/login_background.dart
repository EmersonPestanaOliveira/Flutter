import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/splash_background.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x3300D28B),
                Color(0xD9001510),
                Color(0xF7001510),
              ],
              stops: [0, 0.48, 1],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
