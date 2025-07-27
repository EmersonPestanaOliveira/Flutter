import 'package:chat_reactions/widgets/reaction_bar.dart';
import 'package:chat_reactions/widgets/reaction_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/chat_reaction.dart';

class ReactionButtonScreen extends StatefulWidget {
  const ReactionButtonScreen({super.key});

  @override
  State<ReactionButtonScreen> createState() => _ReactionButtonScreenState();
}

class _ReactionButtonScreenState extends State<ReactionButtonScreen> {
  bool showReactions = false;
  ChatReaction? selectedReaction;
  int? hoveredIndex;

  void _toggleReactions() {
    setState(() => showReactions = !showReactions);
  }

  void _selectReaction(ChatReaction reaction) {
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
              onEnd: () => overlayEntry.remove(), // Agora está OK
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

  @override
  Widget build(BuildContext context) {
    final reactions = ChatReaction.values;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * 0.8;

        return SizedBox(
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ReactionBar(
                show: showReactions,
                reactions: reactions,
                hoveredIndex: hoveredIndex,
                onHover: (index) {
                  setState(() => hoveredIndex = index >= 0 ? index : null);
                },
                onSelect: _selectReaction,
              ),

              ReactionToggleButton(
                selectedReaction: selectedReaction,
                onTap: _toggleReactions,
                width: width,
              ),
            ],
          ),
        );
      },
    );
  }
}
