import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String label;
  final String initialValue;

  const InputField({
    super.key,
    required this.label,
    required this.initialValue,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late String value;

  @override
  void initState() {
    super.initState();
    // Inicializa o valor com o valor passado
    value = widget.initialValue;
  }

  void _updateValue(String newValue) {
    setState(() {
      value = newValue;
    });
  }

  // Função para abrir o dialog de seleção
  void _openGenderSelectionDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(30, 53, 87, 1),
          title: Text(
            'Escolha o Gênero',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Macho',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _updateValue('Macho');
                  Navigator.pop(context); // Fecha o diálogo
                },
              ),
              ListTile(
                title: Text(
                  'Fêmea',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _updateValue('Fêmea');
                  Navigator.pop(context); // Fecha o diálogo
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Ajuste das bordas
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 10, // Aumentei o tamanho do texto do rótulo
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14, // Ajustei o tamanho da fonte do valor
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                  GestureDetector(
                    onTap: _openGenderSelectionDialog,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
