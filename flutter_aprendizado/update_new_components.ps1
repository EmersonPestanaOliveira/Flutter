$ErrorActionPreference = "Stop"

function Write-File {
    param(
        [string]$Path,
        [string]$Content
    )

    $dir = Split-Path -Parent $Path
    if ($dir -and !(Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }

    Set-Content -Path $Path -Value $Content -Encoding UTF8
}

Write-Host "Atualizando projeto com novos componentes..."

Write-File "lib\pages\material\material_display_page.dart" @'
import 'package:flutter/material.dart';
import '../../data/material/display_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialDisplayPage extends StatelessWidget {
  const MaterialDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material / Display',
      entries: materialDisplayEntries,
    );
  }
}
'@

Write-File "lib\pages\material\material_pickers_page.dart" @'
import 'package:flutter/material.dart';
import '../../data/material/picker_entries.dart';
import '../catalog/category_grid_page.dart';

class MaterialPickersPage extends StatelessWidget {
  const MaterialPickersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryGridPage(
      title: 'Material / Pickers',
      entries: materialPickerEntries,
    );
  }
}
'@

Write-File "lib\data\material\material_category_entries.dart" @'
import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../pages/material/material_buttons_page.dart';
import '../../pages/material/material_display_page.dart';
import '../../pages/material/material_feedback_page.dart';
import '../../pages/material/material_inputs_page.dart';
import '../../pages/material/material_pickers_page.dart';
import '../../pages/material/material_selection_page.dart';
import '../../pages/material/material_surfaces_page.dart';

const List<CatalogEntry> materialCategoryEntries = [
  CatalogEntry(
    title: 'Botões',
    icon: Icons.smart_button,
    pageBuilder: _buttonsPage,
  ),
  CatalogEntry(
    title: 'Inputs',
    icon: Icons.text_fields,
    pageBuilder: _inputsPage,
  ),
  CatalogEntry(
    title: 'Feedback',
    icon: Icons.notifications_active,
    pageBuilder: _feedbackPage,
  ),
  CatalogEntry(
    title: 'Seleção',
    icon: Icons.checklist,
    pageBuilder: _selectionPage,
  ),
  CatalogEntry(
    title: 'Pickers',
    icon: Icons.calendar_month,
    pageBuilder: _pickersPage,
  ),
  CatalogEntry(
    title: 'Display',
    icon: Icons.image,
    pageBuilder: _displayPage,
  ),
  CatalogEntry(
    title: 'Superfície',
    icon: Icons.layers,
    pageBuilder: _surfacesPage,
  ),
];

Widget _buttonsPage() => const MaterialButtonsPage();
Widget _inputsPage() => const MaterialInputsPage();
Widget _feedbackPage() => const MaterialFeedbackPage();
Widget _selectionPage() => const MaterialSelectionPage();
Widget _pickersPage() => const MaterialPickersPage();
Widget _displayPage() => const MaterialDisplayPage();
Widget _surfacesPage() => const MaterialSurfacesPage();
'@

Write-File "lib\data\material\button_entries.dart" @'
import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/buttons/dropdown_menu_playground.dart';
import '../../playgrounds/material/buttons/elevated_button_playground.dart';
import '../../playgrounds/material/buttons/fab_playground.dart';
import '../../playgrounds/material/buttons/filled_button_playground.dart';
import '../../playgrounds/material/buttons/filled_tonal_button_playground.dart';
import '../../playgrounds/material/buttons/icon_button_playground.dart';
import '../../playgrounds/material/buttons/outlined_button_playground.dart';
import '../../playgrounds/material/buttons/text_button_playground.dart';

const List<CatalogEntry> materialButtonEntries = [
  CatalogEntry(
    title: 'ElevatedButton',
    icon: Icons.smart_button,
    pageBuilder: _elevated,
  ),
  CatalogEntry(
    title: 'FilledButton',
    icon: Icons.rectangle,
    pageBuilder: _filled,
  ),
  CatalogEntry(
    title: 'FilledButton Tonal',
    icon: Icons.rectangle_outlined,
    pageBuilder: _filledTonal,
  ),
  CatalogEntry(
    title: 'OutlinedButton',
    icon: Icons.crop_square,
    pageBuilder: _outlined,
  ),
  CatalogEntry(
    title: 'TextButton',
    icon: Icons.text_fields,
    pageBuilder: _textButton,
  ),
  CatalogEntry(
    title: 'IconButton',
    icon: Icons.ads_click,
    pageBuilder: _iconButton,
  ),
  CatalogEntry(
    title: 'Floating Action Button',
    icon: Icons.add_circle,
    pageBuilder: _fab,
  ),
  CatalogEntry(
    title: 'DropdownMenu',
    icon: Icons.arrow_drop_down_circle,
    pageBuilder: _dropdown,
  ),
];

Widget _elevated() => const ElevatedButtonPlayground();
Widget _filled() => const FilledButtonPlayground();
Widget _filledTonal() => const FilledTonalButtonPlayground();
Widget _outlined() => const OutlinedButtonPlayground();
Widget _textButton() => const TextButtonPlayground();
Widget _iconButton() => const IconButtonPlayground();
Widget _fab() => const FabPlayground();
Widget _dropdown() => const DropdownMenuPlayground();
'@

Write-File "lib\data\material\input_entries.dart" @'
import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/inputs/slider_playground.dart';
import '../../playgrounds/material/inputs/spinner_playground.dart';
import '../../playgrounds/material/inputs/text_box_playground.dart';
import '../../playgrounds/material/inputs/text_field_playground.dart';

const List<CatalogEntry> materialInputEntries = [
  CatalogEntry(
    title: 'TextField',
    icon: Icons.text_fields,
    pageBuilder: _textField,
  ),
  CatalogEntry(
    title: 'Text Box',
    icon: Icons.notes,
    pageBuilder: _textBox,
  ),
  CatalogEntry(
    title: 'Slider',
    icon: Icons.tune,
    pageBuilder: _slider,
  ),
  CatalogEntry(
    title: 'Spinner',
    icon: Icons.arrow_drop_down_circle,
    pageBuilder: _spinner,
  ),
];

Widget _textField() => const TextFieldPlayground();
Widget _textBox() => const TextBoxPlayground();
Widget _slider() => const SliderPlayground();
Widget _spinner() => const SpinnerPlayground();
'@

Write-File "lib\data\material\feedback_entries.dart" @'
import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/feedback/circular_progress_playground.dart';
import '../../playgrounds/material/feedback/custom_progress_playground.dart';
import '../../playgrounds/material/feedback/linear_progress_playground.dart';
import '../../playgrounds/material/feedback/notifier_playground.dart';
import '../../playgrounds/material/feedback/snackbar_playground.dart';
import '../../playgrounds/material/feedback/spotlight_playground.dart';
import '../../playgrounds/material/feedback/state_progress_bar_playground.dart';

const List<CatalogEntry> materialFeedbackEntries = [
  CatalogEntry(
    title: 'Circular Progress',
    icon: Icons.autorenew,
    pageBuilder: _circular,
  ),
  CatalogEntry(
    title: 'Custom Progress',
    icon: Icons.equalizer,
    pageBuilder: _custom,
  ),
  CatalogEntry(
    title: 'Linear Progressbar',
    icon: Icons.linear_scale,
    pageBuilder: _linear,
  ),
  CatalogEntry(
    title: 'Notifier',
    icon: Icons.notifications,
    pageBuilder: _notifier,
  ),
  CatalogEntry(
    title: 'Snackbar',
    icon: Icons.view_headline,
    pageBuilder: _snackbar,
  ),
  CatalogEntry(
    title: 'Spotlight',
    icon: Icons.lightbulb,
    pageBuilder: _spotlight,
  ),
  CatalogEntry(
    title: 'State Progress Bar',
    icon: Icons.done_all,
    pageBuilder: _state,
  ),
];

Widget _circular() => const CircularProgressPlayground();
Widget _custom() => const CustomProgressPlayground();
Widget _linear() => const LinearProgressPlayground();
Widget _notifier() => const NotifierPlayground();
Widget _snackbar() => const SnackBarPlayground();
Widget _spotlight() => const SpotlightPlayground();
Widget _state() => const StateProgressBarPlayground();
'@

Write-File "lib\data\material\selection_entries.dart" @'
import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/selection/checkbox_playground.dart';
import '../../playgrounds/material/selection/list_picker_playground.dart';
import '../../playgrounds/material/selection/radio_playground.dart';
import '../../playgrounds/material/selection/rating_bar_playground.dart';
import '../../playgrounds/material/selection/switch_playground.dart';

const List<CatalogEntry> materialSelectionEntries = [
  CatalogEntry(
    title: 'Checkbox',
    icon: Icons.check_box,
    pageBuilder: _checkbox,
  ),
  CatalogEntry(
    title: 'List Picker',
    icon: Icons.list_alt,
    pageBuilder: _listPicker,
  ),
  CatalogEntry(
    title: 'Radio Button',
    icon: Icons.radio_button_checked,
    pageBuilder: _radio,
  ),
  CatalogEntry(
    title: 'Rating Bar',
    icon: Icons.star_border,
    pageBuilder: _rating,
  ),
  CatalogEntry(
    title: 'Switch',
    icon: Icons.toggle_on,
    pageBuilder: _switch,
  ),
];

Widget _checkbox() => const CheckboxPlayground();
Widget _listPicker() => const ListPickerPlayground();
Widget _radio() => const RadioPlayground();
Widget _rating() => const RatingBarPlayground();
Widget _switch() => const SwitchPlayground();
'@

Write-File "lib\data\material\picker_entries.dart" @'
import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/pickers/date_picker_playground.dart';
import '../../playgrounds/material/pickers/time_picker_playground.dart';

const List<CatalogEntry> materialPickerEntries = [
  CatalogEntry(
    title: 'Date Picker',
    icon: Icons.date_range,
    pageBuilder: _date,
  ),
  CatalogEntry(
    title: 'Time Picker',
    icon: Icons.access_time,
    pageBuilder: _time,
  ),
];

Widget _date() => const DatePickerPlayground();
Widget _time() => const TimePickerPlayground();
'@

Write-File "lib\data\material\display_entries.dart" @'
import 'package:flutter/material.dart';
import '../../models/catalog_entry.dart';
import '../../playgrounds/material/display/image_playground.dart';
import '../../playgrounds/material/display/label_playground.dart';

const List<CatalogEntry> materialDisplayEntries = [
  CatalogEntry(
    title: 'Image',
    icon: Icons.image,
    pageBuilder: _image,
  ),
  CatalogEntry(
    title: 'Label',
    icon: Icons.label,
    pageBuilder: _label,
  ),
];

Widget _image() => const ImagePlayground();
Widget _label() => const LabelPlayground();
'@

Write-File "lib\playgrounds\material\inputs\slider_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class SliderPlayground extends StatefulWidget {
  const SliderPlayground({super.key});

  @override
  State<SliderPlayground> createState() => _SliderPlaygroundState();
}

class _SliderPlaygroundState extends State<SliderPlayground> {
  double value = 40;
  double min = 0;
  double max = 100;
  int divisions = 5;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Slider',
      preview: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 280,
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              label: value.round().toString(),
              onChanged: (newValue) => setState(() => value = newValue),
            ),
          ),
          Text('Valor: ${value.toStringAsFixed(0)}'),
        ],
      ),
      controls: [
        SliderControl(
          label: 'Value',
          value: value,
          min: min,
          max: max,
          onChanged: (newValue) => setState(() => value = newValue),
        ),
        SliderControl(
          label: 'Max',
          value: max,
          min: 10,
          max: 200,
          onChanged: (newValue) {
            setState(() {
              max = newValue;
              if (value > max) value = max;
            });
          },
        ),
        SliderControl(
          label: 'Divisions',
          value: divisions.toDouble(),
          min: 1,
          max: 20,
          onChanged: (newValue) {
            setState(() => divisions = newValue.round());
          },
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\inputs\spinner_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/playground_page.dart';

class SpinnerPlayground extends StatefulWidget {
  const SpinnerPlayground({super.key});

  @override
  State<SpinnerPlayground> createState() => _SpinnerPlaygroundState();
}

class _SpinnerPlaygroundState extends State<SpinnerPlayground> {
  final items = ['Masculino', 'Feminino', 'Outro'];
  String? selected = 'Masculino';
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Spinner',
      preview: SizedBox(
        width: 280,
        child: DropdownButtonFormField<String>(
          value: selected,
          decoration: const InputDecoration(
            labelText: 'Selecione',
            border: OutlineInputBorder(),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: enabled
              ? (value) => setState(() => selected = value)
              : null,
        ),
      ),
      controls: [
        SwitchListTile(
          title: const Text('Habilitado'),
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\inputs\text_box_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class TextBoxPlayground extends StatefulWidget {
  const TextBoxPlayground({super.key});

  @override
  State<TextBoxPlayground> createState() => _TextBoxPlaygroundState();
}

class _TextBoxPlaygroundState extends State<TextBoxPlayground> {
  String label = 'Descrição';
  String hint = 'Digite um texto maior';
  int maxLines = 4;
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Text Box',
      preview: SizedBox(
        width: 300,
        child: TextField(
          enabled: enabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      controls: [
        TextControl(
          label: 'Label',
          initialValue: label,
          onChanged: (value) => setState(() => label = value),
        ),
        TextControl(
          label: 'Hint',
          initialValue: hint,
          onChanged: (value) => setState(() => hint = value),
        ),
        SwitchListTile(
          title: const Text('Habilitado'),
          value: enabled,
          onChanged: (value) => setState(() => enabled = value),
        ),
        SliderControl(
          label: 'Max lines',
          value: maxLines.toDouble(),
          min: 2,
          max: 10,
          onChanged: (value) => setState(() => maxLines = value.round()),
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\feedback\circular_progress_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class CircularProgressPlayground extends StatefulWidget {
  const CircularProgressPlayground({super.key});

  @override
  State<CircularProgressPlayground> createState() =>
      _CircularProgressPlaygroundState();
}

class _CircularProgressPlaygroundState
    extends State<CircularProgressPlayground> {
  double progress = 0.7;
  double strokeWidth = 6;
  bool determinate = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Circular Progress',
      preview: CircularProgressIndicator(
        value: determinate ? progress : null,
        strokeWidth: strokeWidth,
      ),
      controls: [
        SwitchListTile(
          title: const Text('Determinate'),
          value: determinate,
          onChanged: (value) => setState(() => determinate = value),
        ),
        if (determinate)
          SliderControl(
            label: 'Progress',
            value: progress,
            min: 0,
            max: 1,
            fractionDigits: 2,
            onChanged: (value) => setState(() => progress = value),
          ),
        SliderControl(
          label: 'Stroke width',
          value: strokeWidth,
          min: 2,
          max: 16,
          onChanged: (value) => setState(() => strokeWidth = value),
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\feedback\linear_progress_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class LinearProgressPlayground extends StatefulWidget {
  const LinearProgressPlayground({super.key});

  @override
  State<LinearProgressPlayground> createState() =>
      _LinearProgressPlaygroundState();
}

class _LinearProgressPlaygroundState extends State<LinearProgressPlayground> {
  double progress = 0.5;
  double minHeight = 8;
  bool determinate = true;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Linear Progressbar',
      preview: SizedBox(
        width: 280,
        child: LinearProgressIndicator(
          value: determinate ? progress : null,
          minHeight: minHeight,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      controls: [
        SwitchListTile(
          title: const Text('Determinate'),
          value: determinate,
          onChanged: (value) => setState(() => determinate = value),
        ),
        if (determinate)
          SliderControl(
            label: 'Progress',
            value: progress,
            min: 0,
            max: 1,
            fractionDigits: 2,
            onChanged: (value) => setState(() => progress = value),
          ),
        SliderControl(
          label: 'Height',
          value: minHeight,
          min: 4,
          max: 20,
          onChanged: (value) => setState(() => minHeight = value),
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\feedback\custom_progress_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class CustomProgressPlayground extends StatefulWidget {
  const CustomProgressPlayground({super.key});

  @override
  State<CustomProgressPlayground> createState() =>
      _CustomProgressPlaygroundState();
}

class _CustomProgressPlaygroundState extends State<CustomProgressPlayground> {
  double progress = 0.6;
  double height = 16;
  double radius = 20;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Custom Progress',
      preview: SizedBox(
        width: 280,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              Container(
                height: height,
                color: Colors.grey.shade300,
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: height,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
      controls: [
        SliderControl(
          label: 'Progress',
          value: progress,
          min: 0,
          max: 1,
          fractionDigits: 2,
          onChanged: (value) => setState(() => progress = value),
        ),
        SliderControl(
          label: 'Height',
          value: height,
          min: 6,
          max: 30,
          onChanged: (value) => setState(() => height = value),
        ),
        SliderControl(
          label: 'Radius',
          value: radius,
          min: 0,
          max: 30,
          onChanged: (value) => setState(() => radius = value),
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\feedback\notifier_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';

class NotifierPlayground extends StatefulWidget {
  const NotifierPlayground({super.key});

  @override
  State<NotifierPlayground> createState() => _NotifierPlaygroundState();
}

class _NotifierPlaygroundState extends State<NotifierPlayground> {
  String title = 'Novo treino disponível';
  String message = 'Seu plano foi atualizado.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifier')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications, color: Colors.deepPurple),
                title: Text(title),
                subtitle: Text(message),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 24),
            TextControl(
              label: 'Título',
              initialValue: title,
              onChanged: (value) => setState(() => title = value),
            ),
            TextControl(
              label: 'Mensagem',
              initialValue: message,
              onChanged: (value) => setState(() => message = value),
            ),
          ],
        ),
      ),
    );
  }
}
'@

Write-File "lib\playgrounds\material\feedback\spotlight_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class SpotlightPlayground extends StatefulWidget {
  const SpotlightPlayground({super.key});

  @override
  State<SpotlightPlayground> createState() => _SpotlightPlaygroundState();
}

class _SpotlightPlaygroundState extends State<SpotlightPlayground> {
  String title = 'Dica do dia';
  String message = 'Mantenha constância nos treinos.';

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Spotlight',
      preview: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.shade400),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb, size: 32, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
      ),
      controls: [
        TextControl(
          label: 'Título',
          initialValue: title,
          onChanged: (value) => setState(() => title = value),
        ),
        TextControl(
          label: 'Mensagem',
          initialValue: message,
          onChanged: (value) => setState(() => message = value),
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\feedback\state_progress_bar_playground.dart" @'
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
  final steps = ['Início', 'Plano', 'Treino', 'Fim'];

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
'@

Write-File "lib\playgrounds\material\selection\rating_bar_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class RatingBarPlayground extends StatefulWidget {
  const RatingBarPlayground({super.key});

  @override
  State<RatingBarPlayground> createState() => _RatingBarPlaygroundState();
}

class _RatingBarPlaygroundState extends State<RatingBarPlayground> {
  int rating = 3;
  int totalStars = 5;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Rating Bar',
      preview: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalStars, (index) {
          final filled = index < rating;
          return IconButton(
            onPressed: () => setState(() => rating = index + 1),
            icon: Icon(
              filled ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 34,
            ),
          );
        }),
      ),
      controls: [
        SliderControl(
          label: 'Rating',
          value: rating.toDouble(),
          min: 1,
          max: totalStars.toDouble(),
          onChanged: (value) => setState(() => rating = value.round()),
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\selection\list_picker_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/playground_page.dart';

class ListPickerPlayground extends StatefulWidget {
  const ListPickerPlayground({super.key});

  @override
  State<ListPickerPlayground> createState() => _ListPickerPlaygroundState();
}

class _ListPickerPlaygroundState extends State<ListPickerPlayground> {
  final items = ['Iniciante', 'Intermediário', 'Avançado'];
  String selected = 'Iniciante';

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'List Picker',
      preview: SizedBox(
        width: 280,
        child: DropdownButtonFormField<String>(
          value: selected,
          decoration: const InputDecoration(
            labelText: 'Nível',
            border: OutlineInputBorder(),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => selected = value);
            }
          },
        ),
      ),
      controls: [
        ListTile(
          title: Text('Selecionado: $selected'),
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\pickers\date_picker_playground.dart" @'
import 'package:flutter/material.dart';

class DatePickerPlayground extends StatefulWidget {
  const DatePickerPlayground({super.key});

  @override
  State<DatePickerPlayground> createState() => _DatePickerPlaygroundState();
}

class _DatePickerPlaygroundState extends State<DatePickerPlayground> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date Picker')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              initialDate: selectedDate ?? DateTime.now(),
            );

            if (result != null) {
              setState(() => selectedDate = result);
            }
          },
          icon: const Icon(Icons.date_range),
          label: Text(
            selectedDate == null
                ? 'Selecionar data'
                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
          ),
        ),
      ),
    );
  }
}
'@

Write-File "lib\playgrounds\material\pickers\time_picker_playground.dart" @'
import 'package:flutter/material.dart';

class TimePickerPlayground extends StatefulWidget {
  const TimePickerPlayground({super.key});

  @override
  State<TimePickerPlayground> createState() => _TimePickerPlaygroundState();
}

class _TimePickerPlaygroundState extends State<TimePickerPlayground> {
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Picker')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
            );

            if (result != null) {
              setState(() => selectedTime = result);
            }
          },
          icon: const Icon(Icons.access_time),
          label: Text(
            selectedTime == null
                ? 'Selecionar horário'
                : selectedTime!.format(context),
          ),
        ),
      ),
    );
  }
}
'@

Write-File "lib\playgrounds\material\display\image_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class ImagePlayground extends StatefulWidget {
  const ImagePlayground({super.key});

  @override
  State<ImagePlayground> createState() => _ImagePlaygroundState();
}

class _ImagePlaygroundState extends State<ImagePlayground> {
  double width = 180;
  double height = 120;
  double radius = 12;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Image',
      preview: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          'https://picsum.photos/400/240',
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              width: width,
              height: height,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Icon(Icons.image, size: 48),
            );
          },
        ),
      ),
      controls: [
        SliderControl(
          label: 'Width',
          value: width,
          min: 100,
          max: 320,
          onChanged: (value) => setState(() => width = value),
        ),
        SliderControl(
          label: 'Height',
          value: height,
          min: 80,
          max: 240,
          onChanged: (value) => setState(() => height = value),
        ),
        SliderControl(
          label: 'Radius',
          value: radius,
          min: 0,
          max: 30,
          onChanged: (value) => setState(() => radius = value),
        ),
      ],
    );
  }
}
'@

Write-File "lib\playgrounds\material\display\label_playground.dart" @'
import 'package:flutter/material.dart';
import '../../../widgets/playground/control_widgets.dart';
import '../../../widgets/playground/playground_page.dart';

class LabelPlayground extends StatefulWidget {
  const LabelPlayground({super.key});

  @override
  State<LabelPlayground> createState() => _LabelPlaygroundState();
}

class _LabelPlaygroundState extends State<LabelPlayground> {
  String text = 'Premium';
  double fontSize = 16;
  double radius = 20;

  @override
  Widget build(BuildContext context) {
    return PlaygroundPage(
      title: 'Label',
      preview: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      controls: [
        TextControl(
          label: 'Texto',
          initialValue: text,
          onChanged: (value) => setState(() => text = value),
        ),
        SliderControl(
          label: 'Font size',
          value: fontSize,
          min: 10,
          max: 28,
          onChanged: (value) => setState(() => fontSize = value),
        ),
        SliderControl(
          label: 'Radius',
          value: radius,
          min: 0,
          max: 40,
          onChanged: (value) => setState(() => radius = value),
        ),
      ],
    );
  }
}
'@

Write-Host ""
Write-Host "Atualização concluída."
Write-Host "Agora rode:"
Write-Host "flutter clean"
Write-Host "flutter pub get"
Write-Host "flutter run"