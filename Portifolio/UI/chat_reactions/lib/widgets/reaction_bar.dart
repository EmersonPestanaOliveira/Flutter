import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/chat_reaction.dart';

class ReactionBar extends StatelessWidget {
  final bool show;
  final List<ChatReaction> reactions;
  final int? hoveredIndex;
  final ValueChanged<int> onHover;
  final ValueChanged<ChatReaction> onSelect;

  const ReactionBar({
    super.key,
    required this.show,
    required this.reactions,
    required this.hoveredIndex,
    required this.onHover,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: show ? const Offset(0, -1.0) : const Offset(0, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: show ? 1.0 : 0.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(reactions.length, (index) {
              final reaction = reactions[index];
              return GestureDetector(
                onTap: () => onSelect(reaction),
                child: MouseRegion(
                  onEnter: (_) => onHover(index),
                  onExit: (_) => onHover(-1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: hoveredIndex == index ? 60 : 40,
                    height: hoveredIndex == index ? 60 : 40,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Lottie.asset(
                      reaction.assetPath,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
