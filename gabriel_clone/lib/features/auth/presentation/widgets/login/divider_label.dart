import 'package:flutter/material.dart';

import '../../../../../core/design_system/app_spacing.dart';

class DividerLabel extends StatelessWidget {
  const DividerLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0x4DFFFFFF))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'ou continue com',
            style: TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Color(0x4DFFFFFF))),
      ],
    );
  }
}
