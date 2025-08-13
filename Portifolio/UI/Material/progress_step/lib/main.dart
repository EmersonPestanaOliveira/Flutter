import 'package:flutter/material.dart';

void main() {
  runApp(StepProgressDemoApp());
}

class StepProgressDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step Progress Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StepProgressDemoPage(),
    );
  }
}

class StepProgressDemoPage extends StatefulWidget {
  @override
  _StepProgressDemoPageState createState() => _StepProgressDemoPageState();
}

class _StepProgressDemoPageState extends State<StepProgressDemoPage> {
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step Progress Demo'),
      ),
      body: Column(
        children: [
          Stepper(
            currentStep: _currentStep,
            onStepTapped: (step) {
              setState(() {
                _currentStep = step;
              });
            },
            onStepContinue: _nextStep,
            onStepCancel: _previousStep,
            steps: [
              Step(
                title: Text('Step 1'),
                content: Text('This is the first step.'),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Step 2'),
                content: Text('This is the second step.'),
                isActive: _currentStep >= 1,
                state:
                    _currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Step 3'),
                content: Text('This is the third step.'),
                isActive: _currentStep >= 2,
                state:
                    _currentStep > 2 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Step 4'),
                content: Text('This is the final step.'),
                isActive: _currentStep >= 3,
                state:
                    _currentStep == 3 ? StepState.complete : StepState.indexed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
