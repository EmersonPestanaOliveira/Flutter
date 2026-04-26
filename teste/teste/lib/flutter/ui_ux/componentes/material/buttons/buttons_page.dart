import 'package:flutter/material.dart';

import 'components/elevated_button_playground.dart';
import 'components/filled_button_playground.dart';
import 'components/floating_action_button_playground.dart';
import 'components/icon_button_playground.dart';
import 'components/menu_anchor_playground.dart';
import 'components/outlined_button_playground.dart';
import 'components/popup_menu_button_playground.dart';
import 'components/segmented_button_playground.dart';
import 'components/text_button_playground.dart';
import 'components/toggle_buttons_playground.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Botões Material')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ElevatedButtonPlayground(),
          SizedBox(height: 16),

          FilledButtonPlayground(),
          SizedBox(height: 16),

          OutlinedButtonPlayground(),
          SizedBox(height: 16),

          TextButtonPlayground(),
          SizedBox(height: 16),

          IconButtonPlayground(),
          SizedBox(height: 16),

          FloatingActionButtonPlayground(),
          SizedBox(height: 16),

          ToggleButtonsPlayground(),
          SizedBox(height: 16),

          SegmentedButtonPlayground(),
          SizedBox(height: 16),

          PopupMenuButtonPlayground(),
          SizedBox(height: 16),

          MenuAnchorPlayground(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
