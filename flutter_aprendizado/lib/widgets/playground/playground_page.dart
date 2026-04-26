import 'package:flutter/material.dart';

class PlaygroundPage extends StatelessWidget {
  final String title;
  final Widget preview;
  final List<Widget> controls;

  const PlaygroundPage({
    super.key,
    required this.title,
    required this.preview,
    required this.controls,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surface,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: preview,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: controls,
            ),
          ),
        ],
      ),
    );
  }
}
