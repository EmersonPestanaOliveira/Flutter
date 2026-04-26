import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../cubit/home_cubit.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({required this.tabIndex, super.key});

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            color: Color(0x33000000),
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: SegmentedButton<int>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 0, label: Text('Camaleoes')),
            ButtonSegment(value: 1, label: Text('Alertas')),
          ],
          selected: {tabIndex},
          onSelectionChanged: (selection) {
            context.read<HomeCubit>().changeTab(selection.first);
          },
        ),
      ),
    );
  }
}