import 'package:flutter/material.dart';
import 'package:manju/commons/notification_service.dart';
import '../../clients/data/clients_repository.dart';
import '../../clients/data/clients_model.dart';
import '../../products/data/products_repository.dart';
import '../../products/data/product_model.dart';
import '../data/appointment_model.dart';
import '../data/agenda_repository.dart';

class AgendaFormPage extends StatefulWidget {
  final AppointmentModel? appointment;

  const AgendaFormPage({super.key, this.appointment});

  @override
  State<AgendaFormPage> createState() => _AgendaFormPageState();
}

class _AgendaFormPageState extends State<AgendaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final repo = AgendaRepository();
  final clientsRepo = ClientsRepository();
  final productsRepo = ProductsRepository();

  List<ClientModel> clients = [];
  List<ProductModel> products = [];

  ClientModel? selectedClient;
  ProductModel? selectedProduct;

  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();

    if (widget.appointment != null) {
      selectedDate = widget.appointment!.date;
      selectedTime = widget.appointment!.time;
    }
  }

  Future<void> _loadData() async {
    final clientsData = await clientsRepo.readAll();
    final productsData = await productsRepo.readAll();

    setState(() {
      clients = clientsData;
      products = productsData;
      isLoading = false; // 🔥 Finaliza o loading

      if (widget.appointment != null) {
        if (clients.isNotEmpty) {
          selectedClient = clients.firstWhere(
            (c) => c.id == widget.appointment!.clientId,
            orElse: () => clients.first,
          );
        }

        if (products.isNotEmpty) {
          selectedProduct = products.firstWhere(
            (p) => p.id == widget.appointment!.productId,
            orElse: () => products.first,
          );
        }

        selectedDate = widget.appointment!.date;
        selectedTime = widget.appointment!.time;
      }
    });
  }

  DateTime _convertToDateTime(DateTime date, String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  Future<bool> hasConflict(DateTime date, String time, int duration) async {
    final existingAppointments = await repo.readAll();

    final sameDayAppointments = existingAppointments.where((a) {
      if (widget.appointment != null && a.id == widget.appointment!.id) {
        return false;
      }
      return a.date.year == date.year &&
          a.date.month == date.month &&
          a.date.day == date.day;
    });

    final newStart = _convertToDateTime(date, time);
    final newEnd = newStart.add(Duration(minutes: duration));

    for (var ap in sameDayAppointments) {
      final existingStart = _convertToDateTime(ap.date, ap.time);

      // 🔥 Pegando o produto diretamente do banco
      final existingProduct = await productsRepo.readById(
        ap.productId,
      ); // 🔥 ESSA LINHA É A CHAVE

      if (existingProduct == null) continue; // Segurança extra

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

  Future<void> _save() async {
    if (_formKey.currentState!.validate() &&
        selectedClient != null &&
        selectedProduct != null) {
      final hasConflictResult = await hasConflict(
        selectedDate,
        selectedTime,
        selectedProduct!.durationMinutes,
      );

      if (hasConflictResult) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Conflito de horário'),
            content: const Text(
              'Não é possível agendar nesse horário. Existe um procedimento em andamento.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      final appointment = AppointmentModel(
        id: widget.appointment?.id,
        clientId: selectedClient!.id!,
        clientName: selectedClient!.name,
        date: selectedDate,
        time: selectedTime,
        productId: selectedProduct!.id!,
        productName: selectedProduct!.name,
      );

      int id;

      if (widget.appointment == null) {
        id = await repo.create(appointment);
      } else {
        await repo.update(appointment);
        id = appointment.id!;
        // 🔥 Se quiser, pode cancelar a notificação anterior antes de atualizar:
        NotificationService.cancelNotification(id);
      }

      /// 🔥 Agendar notificação 30 minutos antes
      final appointmentDateTime = DateTime(
        appointment.date.year,
        appointment.date.month,
        appointment.date.day,
        int.parse(appointment.time.split(':')[0]),
        int.parse(appointment.time.split(':')[1]),
      );

      final reminderTime = appointmentDateTime.subtract(
        const Duration(minutes: 30),
      );

      if (reminderTime.isAfter(DateTime.now())) {
        NotificationService.scheduleNotification(
          id: id,
          title: 'Lembrete de Consulta',
          body:
              'Você tem uma consulta com ${appointment.clientName} às ${appointment.time}',
          scheduledDate: reminderTime,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.appointment != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Consulta' : 'Nova Consulta'),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // 🔥 Mostra carregando
            )
          : clients.isEmpty || products.isEmpty
          ? const Center(child: Text('Cadastre clientes e produtos primeiro.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 🔥 Resto do formulário igual
                    DropdownButtonFormField<ClientModel>(
                      value: selectedClient,
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
                      decoration: const InputDecoration(
                        labelText: 'Selecionar Cliente',
                      ),
                      validator: (value) =>
                          value == null ? 'Selecione um cliente' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<ProductModel>(
                      value: selectedProduct,
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
                      decoration: const InputDecoration(
                        labelText: 'Selecionar Procedimento',
                      ),
                      validator: (value) =>
                          value == null ? 'Selecione um procedimento' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: selectedTime,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Horário',
                            ),
                            onTap: () async {
                              final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                helpText: 'Selecione o horário',
                              );
                              if (timeOfDay != null) {
                                setState(() {
                                  selectedTime = timeOfDay.format(context);
                                });
                              }
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? 'Selecione o horário'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                              text:
                                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Data da Consulta',
                            ),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                locale: const Locale('pt', 'BR'),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? 'Selecione a data'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: Text(isEditing ? 'Salvar Alterações' : 'Agendar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
