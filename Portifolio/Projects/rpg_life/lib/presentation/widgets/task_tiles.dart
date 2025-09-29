import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models.dart';
import '../cubit/daily_cubit.dart';

/// Tarefa do tipo booleano (switch)
class BoolTaskTile extends StatelessWidget {
  const BoolTaskTile({super.key, required this.view});
  final DailyTaskView view;

  @override
  Widget build(BuildContext context) {
    final checked = (view.entry.boolValue ?? 0) == 1;
    return SwitchListTile(
      title: Text(view.task.name),
      subtitle: Text('${view.task.xpPerCompletion} XP'),
      value: checked,
      onChanged: (v) =>
          context.read<DailyCubit>().updateBool(view.entry.id!, v),
    );
  }
}

/// Tarefa do tipo número (com meta/target)
class NumberTaskTile extends StatefulWidget {
  const NumberTaskTile({super.key, required this.view});
  final DailyTaskView view;

  @override
  State<NumberTaskTile> createState() => _NumberTaskTileState();
}

class _NumberTaskTileState extends State<NumberTaskTile> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    final v = widget.view.entry.numericValue;
    _c = TextEditingController(text: v != null ? _fmt(v) : '');
  }

  @override
  void didUpdateWidget(covariant NumberTaskTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final v = widget.view.entry.numericValue;
    final txt = v != null ? _fmt(v) : '';
    if (_c.text != txt) _c.text = txt;
  }

  String _fmt(double d) {
    final s = d.toStringAsFixed(2);
    return s.endsWith('.00') ? d.toStringAsFixed(0) : s;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.view.task;
    final target = t.target;
    final xp = widget.view.task.xpPerCompletion;

    return ListTile(
      title: Text(t.name),
      subtitle: target != null
          ? Text('Meta: ${_fmt(target)} ${t.unit ?? ''} • até $xp XP')
          : Text('até $xp XP'),
      trailing: SizedBox(
        width: 140,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: _c,
                textAlign: TextAlign.end,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '0',
                  suffixText: t.unit,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (txt) {
                  final v = double.tryParse(txt.replaceAll(',', '.'));
                  context
                      .read<DailyCubit>()
                      .updateNumber(widget.view.entry.id!, v);
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Salvar',
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {
                final v = double.tryParse(_c.text.replaceAll(',', '.'));
                context
                    .read<DailyCubit>()
                    .updateNumber(widget.view.entry.id!, v);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarefa do tipo horário (time picker)
class TimeTaskTile extends StatelessWidget {
  const TimeTaskTile({super.key, required this.view});
  final DailyTaskView view;

  @override
  Widget build(BuildContext context) {
    final hhmm = view.entry.timeValue ?? '--:--';
    return ListTile(
      title: Text(view.task.name),
      subtitle: Text('Defina o horário • ${view.task.xpPerCompletion} XP'),
      trailing: FilledButton.tonal(
        onPressed: () async {
          final now = TimeOfDay.now();
          final tod = await showTimePicker(context: context, initialTime: now);
          if (tod != null) {
            final hh = tod.hour.toString().padLeft(2, '0');
            final mm = tod.minute.toString().padLeft(2, '0');
            final s = '$hh:$mm';
            // ignore: use_build_context_synchronously
            await context.read<DailyCubit>().updateTime(view.entry.id!, s);
          }
        },
        child: Text(hhmm),
      ),
    );
  }
}
