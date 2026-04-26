import 'package:flutter/material.dart';
import 'classes_table.dart';
import 'classe_generica.dart';
import 'orientacao_objeto.dart';
import 'setter_getter.dart';
import 'construtores.dart';
import 'heranca.dart';
import 'abstratas.dart';
import 'interfaces.dart';
import 'mixins.dart';
import 'static_members.dart';
import 'extension_methods.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        "Tabela Resumo",
        "Resumo do módulo de classes",
        const ClassesTablePage(),
      ),
      (
        "Classe Genérica",
        "Classe com tipo parametrizado",
        const ClasseGenericaPage(),
      ),
      (
        "Orientação a Objeto",
        "Atributos, métodos e instância",
        const OrientacaoObjetoPage(),
      ),
      (
        "Setter e Getter",
        "Encapsulamento e acesso controlado",
        const SetterGetterPage(),
      ),
      (
        "Construtores",
        "Construtor padrão, nomeado e factory",
        const ConstrutoresPage(),
      ),
      ("Herança", "Classe filha herdando de classe pai", const HerancaPage()),
      ("Abstratas", "Classes e métodos abstratos", const AbstratasPage()),
      ("Interfaces", "Implementação de contratos", const InterfacesPage()),
      ("Mixins", "Reutilização de comportamento", const MixinsPage()),
      ("Static", "Membros estáticos da classe", const StaticMembersPage()),
      (
        "Extension Methods",
        "Adicionar métodos a tipos existentes",
        const ExtensionMethodsPage(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Classe")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return ListTile(
            title: Text(item.$1),
            subtitle: Text(item.$2),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.$3),
              );
            },
          );
        },
      ),
    );
  }
}
