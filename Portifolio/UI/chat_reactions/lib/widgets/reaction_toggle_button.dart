import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/chat_reaction.dart';

class ReactionToggleButton extends StatelessWidget {
  final ChatReaction? selectedReaction;
  final VoidCallback onTap;
  final double width;

  const ReactionToggleButton({
    super.key,
    required this.selectedReaction,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.deepOrange[600],
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.3 * 255).toInt()),
              offset: const Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedReaction != null)
              SizedBox(
                width: 30,
                height: 30,
                child: Lottie.asset(selectedReaction!.assetPath, repeat: false),
              )
            else
              const Icon(Icons.emoji_emotions, color: Colors.yellowAccent),
            const SizedBox(width: 8),
            Text(
              selectedReaction?.label ?? 'Emojis',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
