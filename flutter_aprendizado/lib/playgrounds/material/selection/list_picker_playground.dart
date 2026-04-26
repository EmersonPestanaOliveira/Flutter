import 'package:flutter/material.dart';
import '../../../widgets/playground/playground_page.dart';

class ListPickerPlayground extends StatefulWidget {
  const ListPickerPlayground({super.key});

  @override
  State<ListPickerPlayground> createState() => _ListPickerPlaygroundState();
}

class _ListPickerPlaygroundState extends State<ListPickerPlayground> {
  final items = ['Iniciante', 'IntermediÃ¡rio', 'AvanÃ§ado'];
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
            labelText: 'NÃ­vel',
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
