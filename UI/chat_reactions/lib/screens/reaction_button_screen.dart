import 'package:chat_reactions/widgets/reaction_bar.dart';
import 'package:chat_reactions/widgets/reaction_toggle_button.dart';
import 'package:flutter/material.dart';
import '../constants/chat_reaction.dart';
import '../mixins/reaction_handler_mixin.dart';

class ReactionButtonScreen extends StatefulWidget {
  const ReactionButtonScreen({super.key});

  @override
  State<ReactionButtonScreen> createState() => _ReactionButtonScreenState();
}

class _ReactionButtonScreenState extends State<ReactionButtonScreen>
    with ReactionHandlerMixin {
  @override
  Widget build(BuildContext context) {
    final reactions = ChatReaction.values;

    return Container(
      color: Colors.lightBlue[100],
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: LayoutBuilder(
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
                  onSelect: selectReaction,
                ),
                ReactionToggleButton(
                  selectedReaction: selectedReaction,
                  onTap: toggleReactions,
                  width: width,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
