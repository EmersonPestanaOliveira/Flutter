import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MaterialApp(
    home: VoiceLedControl(),
    debugShowCheckedModeBanner: false,
  ));
}

class VoiceLedControl extends StatefulWidget {
  @override
  _VoiceLedControlState createState() => _VoiceLedControlState();
}

class _VoiceLedControlState extends State<VoiceLedControl> {
  final String deviceIp = 'http://192.168.15.34';
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> sendCommand(String command) async {
    try {
      final response = await http.get(Uri.parse('$deviceIp/$command'));

      if (response.statusCode == 200) {
        showSnack('✅ LED: $command');
      } else {
        showSnack('⚠️ Falha ao enviar comando (status ${response.statusCode})');
      }
    } catch (e) {
      showSnack('❌ Erro: $e');
    }
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Erro: $error'),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          final recognized = result.recognizedWords.toLowerCase();
          setState(() => _lastWords = recognized);

          if (recognized.contains('acender')) {
            sendCommand('on');
          } else if (recognized.contains('apagar')) {
            sendCommand('off');
          }
        });
      } else {
        showSnack('🎤 Reconhecimento de voz não disponível');
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Controle de LED por Voz'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : Colors.grey,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Último comando:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _lastWords,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => sendCommand('on'),
              icon: Icon(Icons.lightbulb),
              label: Text('Ligar LED'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => sendCommand('off'),
              icon: Icon(Icons.lightbulb_outline),
              label: Text('Desligar LED'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleListening,
        child: Icon(_isListening ? Icons.stop : Icons.mic),
        backgroundColor: _isListening ? Colors.red : Colors.indigo,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
