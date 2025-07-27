import 'package:flutter/material.dart';
import '../data/agenda_repository.dart';
import '../data/appointment_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final repo = AgendaRepository();
  List<AppointmentModel> historico = [];

  @override
  void initState() {
    super.initState();
    _loadHistorico();
  }

  Future<void> _loadHistorico() async {
    final data = await repo.readAll();
    setState(() {
      historico = data;
    });
  }

  bool _isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    if (historico.isEmpty) {
      return const Center(child: Text('Nenhum atendimento encontrado.'));
    }

    /// 🔥 Agrupando por cliente
    final Map<String, List<AppointmentModel>> grouped = {};

    for (var item in historico) {
      grouped.putIfAbsent(item.clientName, () => []).add(item);
    }

    final clientes = grouped.keys.toList();

    return ListView.builder(
      itemCount: clientes.length,
      itemBuilder: (context, index) {
        final clientName = clientes[index];
        final consultas = grouped[clientName]!;

        // 🔥 Ordenando do mais recente para o mais antigo
        consultas.sort((a, b) => b.date.compareTo(a.date));

        final totalConsultas = consultas.length;
        final consultasAtivas = consultas
            .where((c) => !_isPastDate(c.date))
            .length;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ExpansionTile(
            title: Text(
              clientName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ativas: $consultasAtivas',
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                ),
                Text('Total: $totalConsultas'),
              ],
            ),
            children: consultas.map((consulta) {
              final isPast = _isPastDate(consulta.date);

              return ListTile(
                tileColor: isPast ? Colors.black12 : null,
                title: Text(
                  'Data: ${consulta.date.day}/${consulta.date.month}/${consulta.date.year}',
                  style: TextStyle(
                    color: isPast ? Colors.red : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Horário: ${consulta.time} • ${consulta.productName}',
                  style: TextStyle(color: isPast ? Colors.red : Colors.black),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
