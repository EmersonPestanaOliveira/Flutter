import 'package:flutter/material.dart';
import 'package:manju/agenda/ui/agenda_package_form_page.dart';
import 'package:manju/clients/data/clients_model.dart';
import 'package:manju/clients/data/clients_repository.dart';
import 'package:manju/financial/ui/transaction_form_page.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/agenda_repository.dart';
import '../data/appointment_model.dart';
import 'agenda_form_page.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage>
    with SingleTickerProviderStateMixin {
  final repo = AgendaRepository();

  late TabController _tabController;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final clientsRepo = ClientsRepository();
  List<AppointmentModel> allAppointments = [];
  List<ClientModel> allClients = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //deleteDatabaseFile();
    _loadAppointments();
    _loadClients();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'agenda.db');
    await deleteDatabase(path);
    print('Banco de dados apagado com sucesso');
  }

  Future<void> _loadAppointments() async {
    final data = await repo.readAll();
    setState(() {
      allAppointments = data;
    });
  }

  Future<void> _loadClients() async {
    final data = await clientsRepo.readAll();
    setState(() {
      allClients = data;
    });
  }

  List<AppointmentModel> _getAppointmentsForDay(DateTime day) {
    final appointments = allAppointments.where((a) {
      return a.date.year == day.year &&
          a.date.month == day.month &&
          a.date.day == day.day;
    }).toList();

    appointments.sort((a, b) {
      final timeA = _parseTime(a.time);
      final timeB = _parseTime(b.time);
      return timeA.compareTo(timeB);
    });

    return appointments;
  }

  /// 🔥 Verifica se tem aniversário no dia
  bool _hasBirthday(DateTime day) {
    return allClients.any((client) {
      if (client.birthday == null) return false;
      return client.birthday!.day == day.day &&
          client.birthday!.month == day.month;
    });
  }

  bool _isPastDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.isBefore(today);
  }

  void _deleteAppointment(int id) async {
    await repo.delete(id);
    _loadAppointments();
  }

  void _navigateToForm({AppointmentModel? appointment}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgendaFormPage(appointment: appointment),
      ),
    );
    _loadAppointments();
  }

  void _showBirthdayPopup(DateTime day) {
    final birthdays = allClients.where((client) {
      if (client.birthday == null) return false;
      return client.birthday!.day == day.day &&
          client.birthday!.month == day.month;
    }).toList();

    if (birthdays.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Aniversariantes 🎂'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: birthdays.map((client) => Text(client.name)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _navigateToReceive(AppointmentModel appointment) async {
    final dateStr =
        '${appointment.date.day.toString().padLeft(2, '0')}/${appointment.date.month.toString().padLeft(2, '0')}/${appointment.date.year}';

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFormPage(
          initialName: 'Recebimento - ${appointment.clientName} - $dateStr',
          initialValue: null, // Pode deixar null para digitar manualmente
          isEntrada: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsToday = _getAppointmentsForDay(_selectedDay!);

    /// 🔥 Agrupando os atendimentos por cliente para a aba Histórico
    final Map<String, List<AppointmentModel>> grouped = {};

    for (var item in allAppointments) {
      grouped.putIfAbsent(item.clientName, () => []).add(item);
    }

    final clientes = grouped.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultas'),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Agenda'),
            Tab(text: 'Histórico'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add_check),
            tooltip: 'Agendar Pacote',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgendaPackageFormPage(),
                ),
              );
              _loadAppointments();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /// 🔸 Aba Agenda
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background_home.jpg',
                  opacity: const AlwaysStoppedAnimation(0.1),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.1),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    locale: 'pt_BR',
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2100),
                    focusedDay: _focusedDay,
                    headerStyle: HeaderStyle(formatButtonVisible: false),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });

                      _showBirthdayPopup(selected);
                    },
                    eventLoader: (day) {
                      return _getAppointmentsForDay(day);
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        final hasBirthday = _hasBirthday(day);

                        List<Widget> markers = [];

                        // 🔥 Bolinhas das consultas
                        if (events.isNotEmpty) {
                          markers.add(
                            Wrap(
                              spacing: 2,
                              children: List.generate(events.length, (index) {
                                return Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            ),
                          );
                        }

                        // 🔥 Bolo de aniversário
                        if (hasBirthday) {
                          markers.add(
                            const Text('🎂', style: TextStyle(fontSize: 16)),
                          );
                        }

                        if (markers.isEmpty) return null;

                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: markers,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListView.builder(
                        itemCount: appointmentsToday.length,
                        itemBuilder: (context, index) {
                          final app = appointmentsToday[index];
                          return Card(
                            child: ListTile(
                              title: Text('${app.time} • ${app.productName}'),
                              subtitle: Text(app.clientName),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.attach_money,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Receber',
                                    onPressed: () => _navigateToReceive(app),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () =>
                                        _navigateToForm(appointment: app),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _deleteAppointment(app.id!),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// 🔸 Aba Histórico com agrupamento
          Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background_home.jpg',
                  opacity: const AlwaysStoppedAnimation(0.1),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.1),
                ),
              ),
              allAppointments.isEmpty
                  ? const Center(child: Text('Nenhum atendimento encontrado.'))
                  : ListView.builder(
                      itemCount: clientes.length,
                      itemBuilder: (context, index) {
                        final clientName = clientes[index];
                        final consultas = grouped[clientName]!;
                        consultas.sort((a, b) => b.date.compareTo(a.date));
                        final totalConsultas = consultas.length;
                        final consultasAtivas = consultas
                            .where((c) => !_isPastDate(c.date))
                            .length;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ExpansionTile(
                            title: Text(
                              clientName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Ativas: $consultasAtivas',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 22,
                                  ),
                                ),
                                Text('Total: $totalConsultas'),
                              ],
                            ),

                            /// 🔥 Children com ordenação aplicada
                            children: () {
                              // 🔥 Ordenando da mais recente para mais antiga
                              final sortedConsultas = [...consultas]
                                ..sort((a, b) => b.date.compareTo(a.date));

                              return sortedConsultas.map((consulta) {
                                final isPast = _isPastDate(consulta.date);

                                return ListTile(
                                  tileColor: isPast ? Colors.black : null,
                                  title: Text(
                                    'Data: ${consulta.date.day}/${consulta.date.month}/${consulta.date.year}',
                                    style: TextStyle(
                                      color: isPast ? Colors.red : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Horário: ${consulta.time} • ${consulta.productName}',
                                    style: TextStyle(
                                      color: isPast ? Colors.red : Colors.black,
                                    ),
                                  ),
                                  trailing: isPast
                                      ? null
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () => _navigateToForm(
                                                appointment: consulta,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  _deleteAppointment(
                                                    consulta.id!,
                                                  ),
                                            ),
                                          ],
                                        ),
                                );
                              }).toList();
                            }(),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
