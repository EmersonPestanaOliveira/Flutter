import 'package:flutter/material.dart';

class Labeled extends StatelessWidget {
  final String label;
  final Widget child;
  const Labeled({required this.label, required this.child});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      child,
    ],
  );
}
