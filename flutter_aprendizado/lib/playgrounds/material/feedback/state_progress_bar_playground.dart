import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class StateProgressBarPlayground extends StatefulWidget {
  const StateProgressBarPlayground({super.key});

  @override
  State<StateProgressBarPlayground> createState() =>
      _StateProgressBarPlaygroundState();
}

class _StateProgressBarPlaygroundState
    extends State<StateProgressBarPlayground> {
  int currentStep = 2;
  final steps = ['InÃ­cio', 'Plano', 'Treino', 'Fim'];

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'State Progress Bar',
      preview: SizedBox(
        width: 320,
        child: Row(
          children: List.generate(steps.length, (index) {
            final active = index <= currentStep;
            return Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: active ? Colors.deepPurple : Colors.grey,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 4,
                        color: index < currentStep
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
      controls: [
        SliderControl(
          label: 'Current step',
          value: currentStep.toDouble(),
          min: 0,
          max: (steps.length - 1).toDouble(),
          onChanged: (value) => setState(() => currentStep = value.round()),
        ),
      ],
    );
  }
}
