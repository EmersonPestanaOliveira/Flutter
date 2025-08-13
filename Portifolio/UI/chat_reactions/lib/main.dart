import 'package:chat_reactions/screens/reaction_button_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReactionExample(),
    ),
  );
}

class ReactionExample extends StatelessWidget {
  const ReactionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Reaction')),
      body: const Center(child: ReactionButtonScreen()),
    );
  }
}
