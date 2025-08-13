import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/chat_reaction.dart';

mixin ReactionHandlerMixin<T extends StatefulWidget> on State<T> {
  bool showReactions = false;
  ChatReaction? selectedReaction;
  int? hoveredIndex;

  void toggleReactions() {
    setState(() => showReactions = !showReactions);
  }

  void selectReaction(ChatReaction reaction) {
    setState(() {
      selectedReaction = reaction;
      showReactions = false;
    });

    showFloatingReaction(reaction);
  }

  void showFloatingReaction(ChatReaction reaction) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: IgnorePointer(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: -300.0),
              duration: const Duration(seconds: 2),
              onEnd: () => overlayEntry.remove(),
              builder: (context, value, child) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: 1 - (value.abs() / 300.0),
                    child: Transform.translate(
                      offset: Offset(0, value),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: Lottie.asset(reaction.assetPath, repeat: false),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);
  }
}
