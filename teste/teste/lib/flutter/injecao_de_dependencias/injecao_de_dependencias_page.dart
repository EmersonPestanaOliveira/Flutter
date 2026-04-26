import 'package:flutter/material.dart';

class InjecaoDeDependenciasPage extends StatelessWidget {
  const InjecaoDeDependenciasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InjeÃ§Ã£o de dependÃªncias'),
      ),
      body: const Center(
        child: Text(
          'InjeÃ§Ã£o de dependÃªncias',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
