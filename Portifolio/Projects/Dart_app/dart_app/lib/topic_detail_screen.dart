import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para copiar texto

class TopicDetailScreen extends StatelessWidget {
  final String topicTitle;
  final String codeExample;
  final String codeOutput;

  const TopicDetailScreen({
    super.key,
    required this.topicTitle,
    required this.codeExample,
    required this.codeOutput,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topicTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Permite rolar o conteúdo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entendendo: $topicTitle',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Seção de Código
            Text(
              'Código:',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.cyan.shade300,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22), // Cor de fundo do card
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.cyan.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis
                        .horizontal, // Permite rolagem horizontal para código longo
                    child: Text(
                      codeExample,
                      style: const TextStyle(
                        fontFamily:
                            'monospace', // Fonte monoespaçada para código
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: codeExample));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Código copiado!'),
                            backgroundColor: Colors.green.shade700,
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copiar Código'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan.shade800,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Seção de Execução (Saída)
            Text(
              'Saída da Execução:',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.cyan.shade300,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12.0),
              width: double.infinity, // Ocupa a largura total
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117), // Cor de fundo do console
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.5)),
              ),
              child: Text(
                codeOutput,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors
                      .lightGreenAccent, // Cor de texto para saída de console
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 30),
            // Adicione mais conteúdo explicativo aqui, se desejar
            Text(
              'Este exemplo demonstra como o Dart pode imprimir uma mensagem no console. A função `main` é o ponto de entrada de qualquer programa Dart, e `print()` é usada para exibir texto.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
