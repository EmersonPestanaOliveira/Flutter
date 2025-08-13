import 'package:flutter/cupertino.dart';

void main() {
  runApp(CupertinoApp(
    theme: CupertinoThemeData(
      brightness: Brightness.light,
    ),
    home: CupertinoWidgetsDemo(),
  ));
}

class CupertinoWidgetsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Cupertino Widgets Demo'),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Text Section
            Text(
              'Texto',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            CupertinoTextField(
              placeholder: 'Digite algo...',
            ),
            SizedBox(height: 16),

            // Botões
            Text(
              'Botões',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            CupertinoButton(
              child: Text('Cupertino Button'),
              onPressed: () {},
            ),
            SizedBox(height: 16),

            // Seletores
            Text(
              'Seletores',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            CupertinoSwitch(
              value: true,
              onChanged: (bool value) {},
            ),
            CupertinoSlider(
              value: 0.5,
              onChanged: (double value) {},
            ),
            SizedBox(height: 16),

            // Data e Hora
            Text(
              'Data e Hora',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            CupertinoButton(
              child: Text('Selecionar Data'),
              onPressed: () => _showDatePicker(context),
            ),
            CupertinoButton(
              child: Text('Selecionar Hora'),
              onPressed: () => _showTimePicker(context),
            ),
            SizedBox(height: 16),

            // Alertas e Contextos
            Text(
              'Alertas',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            CupertinoButton(
              child: Text('Exibir Alerta'),
              onPressed: () => _showAlertDialog(context),
            ),
            CupertinoButton(
              child: Text('Exibir Action Sheet'),
              onPressed: () => _showActionSheet(context),
            ),
            SizedBox(height: 16),

            // Tabs
            Text(
              'Tabs',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            CupertinoSegmentedControl<int>(
              children: {
                0: Text('Tab 1'),
                1: Text('Tab 2'),
              },
              groupValue: 0,
              onValueChanged: (int value) {},
            ),
            SizedBox(height: 16),

            // Loading
            Text(
              'Carregamento',
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime value) {},
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: CupertinoTimerPicker(
          onTimerDurationChanged: (Duration value) {},
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Alerta'),
        content: Text('Este é um alerta Cupertino!'),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: Text('Action Sheet'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Opção 1'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoActionSheetAction(
            child: Text('Opção 2'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
