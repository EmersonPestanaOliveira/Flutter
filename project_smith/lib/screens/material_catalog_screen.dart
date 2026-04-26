import 'package:flutter/material.dart';

class MaterialCatalogScreen extends StatelessWidget {
  const MaterialCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Material')),
      body: ListView(
        children: [
          ExpansionTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Textos'),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            children: [
              // Card para Text
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: const Text('Text'),
                  subtitle: const Text('Exibe um texto simples.'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(context, '/text');
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Card para RichText
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: const Text('RichText'),
                  subtitle: const Text('Permite estilizar partes do texto.'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // ação ao clicar (exemplo)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Você clicou em RichText')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
