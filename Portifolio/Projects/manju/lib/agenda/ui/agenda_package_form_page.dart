import 'package:flutter/material.dart';
import 'package:manju/clients/data/clients_repository.dart';
import 'package:manju/clients/data/clients_model.dart';
import 'package:manju/commons/notification_service.dart';
import 'package:manju/products/data/products_repository.dart';
import 'package:manju/products/data/product_model.dart';
import '../data/agenda_repository.dart';
import '../data/appointment_model.dart';

/// 🔥 Classe auxiliar para armazenar Data + Hora
class DateTimeWithHour {
  final DateTime date;
  final TimeOfDay time;

  DateTimeWithHour({required this.date, required this.time});
}

class AgendaPackageFormPage extends StatefulWidget {
  const AgendaPackageFormPage({super.key});

  @override
  State<AgendaPackageFormPage> createState() => _AgendaPackageFormPageState();
}

class _AgendaPackageFormPageState extends State<AgendaPackageFormPage> {
  final clientsRepo = ClientsRepository();
  final productsRepo = ProductsRepository();
  final agendaRepo = AgendaRepository();

  ClientModel? selectedClient;
  ProductModel? selectedProduct;
  List<DateTimeWithHour> selectedDates = [];

  List<ClientModel> clients = [];
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    clients = await clientsRepo.readAll();
    products = await productsRepo.readAll();
    setState(() {});
  }

  /// 🔥 Adicionar Data + Hora
  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final newItem = DateTimeWithHour(date: date, time: time);

    final exists = selectedDates.any(
      (element) => element.date == newItem.date && element.time == newItem.time,
    );

    if (!exists) {
      setState(() {
        selectedDates.add(newItem);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este horário já foi adicionado.')),
      );
    }
  }

  /// 🔥 Converter time em DateTime completo
  DateTime _convertToDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// 🔥 Verificar conflito com duração
  Future<bool> hasConflict(DateTime date, TimeOfDay time, int duration) async {
    final existingAppointments = await agendaRepo.readAll();

    final sameDayAppointments = existingAppointments.where((a) {
      return a.date.year == date.year &&
          a.date.month == date.month &&
          a.date.day == date.day;
    });

    final newStart = _convertToDateTime(date, time);
    final newEnd = newStart.add(Duration(minutes: duration));

    for (var ap in sameDayAppointments) {
      final existingStart = _convertToDateTime(
        ap.date,
        TimeOfDay(
          hour: int.parse(ap.time.split(':')[0]),
          minute: int.parse(ap.time.split(':')[1]),
        ),
      );

      final existingProduct = await productsRepo.readById(ap.productId);

      if (existingProduct == null) continue;

      final existingEnd = existingStart.add(
        Duration(minutes: existingProduct.durationMinutes),
      );

      final overlap =
          newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart);

      if (overlap) {
        return true;
      }
    }

    return false;
  }

  /// 🔥 Remover item da lista
  void _removeDate(int index) {
    setState(() {
      selectedDates.removeAt(index);
    });
  }

  /// 🔥 Salvar pacote com verificação de conflitos
  Future<void> _savePackage() async {
    if (selectedClient == null ||
        selectedProduct == null ||
        selectedDates.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }

    List<String> conflicts = [];

    for (var item in selectedDates) {
      final date = item.date;
      final time = item.time;
      final conflict = await hasConflict(
        date,
        time,
        selectedProduct!.durationMinutes,
      );

      if (conflict) {
        final dateStr = '${date.day}/${date.month}/${date.year}';
        final timeStr =
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        conflicts.add('$dateStr às $timeStr');
      }
    }

    if (conflicts.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Conflito de Horário'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Já existem consultas nos seguintes horários:'),
                const SizedBox(height: 8),
                ...conflicts.map((c) => Text(c)).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    /// 🔥 Se não houver conflitos, salva tudo e agenda as notificações
    for (var item in selectedDates) {
      final appointment = AppointmentModel(
        clientId: selectedClient!.id!,
        clientName: selectedClient!.name,
        productId: selectedProduct!.id!,
        productName: selectedProduct!.name,
        date: item.date,
        time:
            '${item.time.hour.toString().padLeft(2, '0')}:${item.time.minute.toString().padLeft(2, '0')}',
      );

      final id = await agendaRepo.create(appointment);

      /// 🔥 Agendar notificação 30 minutos antes
      final appointmentDateTime = DateTime(
        item.date.year,
        item.date.month,
        item.date.day,
        item.time.hour,
        item.time.minute,
      );

      final reminderTime = appointmentDateTime.subtract(
        const Duration(minutes: 30),
      );

      if (reminderTime.isAfter(DateTime.now())) {
        NotificationService.scheduleNotification(
          id: id,
          title: 'Lembrete de Consulta',
          body:
              'Você tem uma consulta com ${selectedClient!.name} às ${appointment.time}',
          scheduledDate: reminderTime,
        );
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Pacote'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// 🔸 Seletor de Cliente
            DropdownButtonFormField<ClientModel>(
              value: selectedClient,
              decoration: const InputDecoration(labelText: 'Cliente'),
              items: clients.map((client) {
                return DropdownMenuItem(
                  value: client,
                  child: Text(client.name),
                );
              }).toList(),
              onChanged: (client) {
                setState(() {
                  selectedClient = client;
                });
              },
            ),

            const SizedBox(height: 8),

            /// 🔸 Seletor de Produto
            DropdownButtonFormField<ProductModel>(
              value: selectedProduct,
              decoration: const InputDecoration(labelText: 'Produto'),
              items: products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(product.name),
                );
              }).toList(),
              onChanged: (product) {
                setState(() {
                  selectedProduct = product;
                });
              },
            ),

            const SizedBox(height: 12),

            /// 🔸 Botão Adicionar Data e Hora
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDateTime,
                  child: const Text('Adicionar Data e Hora'),
                ),
                const SizedBox(width: 8),
                Text('${selectedDates.length} adicionados'),
              ],
            ),

            const SizedBox(height: 12),

            /// 🔸 Lista dos itens adicionados
            Expanded(
              child: ListView.builder(
                itemCount: selectedDates.length,
                itemBuilder: (context, index) {
                  final item = selectedDates[index];
                  final dateStr =
                      '${item.date.day}/${item.date.month}/${item.date.year}';
                  final timeStr =
                      '${item.time.hour.toString().padLeft(2, '0')}:${item.time.minute.toString().padLeft(2, '0')}';

                  return ListTile(
                    title: Text('$dateStr às $timeStr'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeDate(index),
                    ),
                  );
                },
              ),
            ),

            /// 🔸 Botão Salvar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              onPressed: _savePackage,
              child: const Text('Salvar Pacote'),
            ),
          ],
        ),
      ),
    );
  }
}
