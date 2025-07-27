import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../data/financial_repository.dart';
import '../data/transaction_model.dart';
import '../data/debt_model.dart';
import 'transaction_form_page.dart';
import 'debt_form_page.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage>
    with SingleTickerProviderStateMixin {
  final repo = FinancialRepository();
  List<TransactionModel> transactions = [];
  List<DebtModel> debts = [];

  // 🔥 Estado dos filtros
  bool filterEntrada = false;
  bool filterSaida = false;
  DateTime? filterDay;
  DateTime? filterMonth;
  DateTime? filterYear;

  String groupBy = 'dia'; // 🔥 Para gráfico: dia ou mês

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final txs = await repo.readAllTransactions();
    final dbts = await repo.readAllDebts();

    setState(() {
      transactions = txs;
      debts = dbts;
    });
  }

  double get totalCash {
    double entrada = transactions
        .where((e) => e.type == 'entrada')
        .fold(0.0, (sum, e) => sum + e.value);
    double saida = transactions
        .where((e) => e.type == 'saida')
        .fold(0.0, (sum, e) => sum + e.value);
    return entrada - saida;
  }

  List<TransactionModel> get filteredTransactions {
    return transactions.where((tx) {
      bool matchesType = true;
      if (filterEntrada && !filterSaida) {
        matchesType = tx.type == 'entrada';
      } else if (filterSaida && !filterEntrada) {
        matchesType = tx.type == 'saida';
      }

      bool matchesDay =
          filterDay == null ||
          (tx.dateTime.year == filterDay!.year &&
              tx.dateTime.month == filterDay!.month &&
              tx.dateTime.day == filterDay!.day);

      bool matchesMonth =
          filterMonth == null ||
          (tx.dateTime.year == filterMonth!.year &&
              tx.dateTime.month == filterMonth!.month);

      bool matchesYear =
          filterYear == null || tx.dateTime.year == filterYear!.year;

      return matchesType && matchesDay && matchesMonth && matchesYear;
    }).toList();
  }

  Map<String, Map<String, double>> get groupedData {
    Map<String, Map<String, double>> data = {};

    for (var tx in filteredTransactions) {
      String key = groupBy == 'dia'
          ? '${tx.dateTime.day}/${tx.dateTime.month}/${tx.dateTime.year}'
          : '${tx.dateTime.month}/${tx.dateTime.year}';

      data.putIfAbsent(key, () => {'entrada': 0, 'saida': 0});

      if (tx.type == 'entrada') {
        data[key]!['entrada'] = data[key]!['entrada']! + tx.value;
      } else {
        data[key]!['saida'] = data[key]!['saida']! + tx.value;
      }
    }

    return data;
  }

  void _deleteTransaction(int id) async {
    await repo.deleteTransaction(id);
    _loadData();
  }

  void _deleteDebt(int id) async {
    await repo.deleteDebt(id);
    _loadData();
  }

  void _navigateToTransactionForm({TransactionModel? tx}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFormPage(transaction: tx),
      ),
    );
    _loadData();
  }

  void _navigateToDebtForm({DebtModel? debt}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DebtFormPage(debt: debt)),
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financeiro'),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Caixa'),
            Tab(text: 'Dívidas'),
            Tab(text: 'Gráfico'),
          ],
        ),
        actions: _tabController.index == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _openFilterDialog,
                ),
              ]
            : null,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCashTab(), _buildDebtsTab(), _buildChartTab()],
      ),
      floatingActionButton: _tabController.index == 0
          ? _buildFABCash()
          : _tabController.index == 1
          ? _buildFABDebt()
          : null,
    );
  }

  // 🔥 Aba Caixa
  Widget _buildCashTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // 🔥 Caixa fixo no topo
          _buildBalanceCard(),

          const SizedBox(height: 16),

          // 🔥 Lista com scroll
          Expanded(
            child: ListView(
              children: [
                _buildSectionTitle('Entradas e Saídas'),
                ...filteredTransactions.map(
                  (e) => Card(
                    child: ListTile(
                      leading: Icon(
                        e.type == 'entrada'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: e.type == 'entrada' ? Colors.green : Colors.red,
                      ),
                      title: Text(e.description),
                      subtitle: Text(
                        '${e.dateTime.day}/${e.dateTime.month}/${e.dateTime.year} - ${e.dateTime.hour}:${e.dateTime.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'R\$ ${e.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: e.type == 'entrada'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _navigateToTransactionForm(tx: e),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTransaction(e.id!),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 Aba Dívidas
  Widget _buildDebtsTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView(
        children: [
          _buildSectionTitle('Dívidas'),
          ...debts.map(
            (e) => Card(
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.orange),
                title: Text(e.name),
                subtitle: Text(
                  'Total: R\$ ${e.totalValue.toStringAsFixed(2)}\n'
                  'Pago: R\$ ${e.paidValue.toStringAsFixed(2)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _navigateToDebtForm(debt: e),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDebt(e.id!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 Aba Gráfico
  Widget _buildChartTab() {
    final data = groupedData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Agrupar por:'),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: groupBy,
                items: const [
                  DropdownMenuItem(value: 'dia', child: Text('Dia')),
                  DropdownMenuItem(value: 'mes', child: Text('Mês')),
                ],
                onChanged: (value) {
                  setState(() {
                    groupBy = value!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: _tabController.index < 2,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= data.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            data[index].key,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(data.length, (index) {
                  final entrada = data[index].value['entrada'] ?? 0;
                  final saida = data[index].value['saida'] ?? 0;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: entrada,
                        color: Colors.green,
                        width: 8,
                      ),
                      BarChartRodData(toY: saida, color: Colors.red, width: 8),
                    ],
                  );
                }),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔥 Comuns
  Widget _buildBalanceCard() {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Saldo em Caixa',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${totalCash.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFABCash() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: () => _navigateToTransactionForm(
            tx: TransactionModel(
              type: 'entrada',
              value: 0,
              dateTime: DateTime.now(),
              description: '',
            ),
          ),
          icon: const Icon(Icons.arrow_downward),
          label: const Text('Entrada'),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () => _navigateToTransactionForm(
            tx: TransactionModel(
              type: 'saida',
              value: 0,
              dateTime: DateTime.now(),
              description: '',
            ),
          ),
          icon: const Icon(Icons.arrow_upward),
          label: const Text('Saída'),
        ),
      ],
    );
  }

  Widget _buildFABDebt() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.orange,
      onPressed: () => _navigateToDebtForm(),
      icon: const Icon(Icons.warning),
      label: const Text('Dívida'),
    );
  }

  // 🔥 Dialog de Filtros
  void _openFilterDialog() {
    bool tempFilterEntrada = filterEntrada;
    bool tempFilterSaida = filterSaida;
    DateTime? tempFilterDay = filterDay;
    DateTime? tempFilterMonth = filterMonth;
    DateTime? tempFilterYear = filterYear;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Filtros'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Mostrar Entradas'),
                      value: tempFilterEntrada,
                      onChanged: (v) =>
                          setStateDialog(() => tempFilterEntrada = v!),
                    ),
                    CheckboxListTile(
                      title: const Text('Mostrar Saídas'),
                      value: tempFilterSaida,
                      onChanged: (v) =>
                          setStateDialog(() => tempFilterSaida = v!),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(
                        tempFilterDay == null
                            ? 'Filtrar por Dia'
                            : 'Dia: ${tempFilterDay!.day}/${tempFilterDay!.month}/${tempFilterDay!.year}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempFilterDay ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setStateDialog(() => tempFilterDay = date);
                        }
                      },
                      onLongPress: () =>
                          setStateDialog(() => tempFilterDay = null),
                    ),
                    ListTile(
                      title: Text(
                        tempFilterMonth == null
                            ? 'Filtrar por Mês'
                            : 'Mês: ${tempFilterMonth!.month}/${tempFilterMonth!.year}',
                      ),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempFilterMonth ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setStateDialog(() => tempFilterMonth = date);
                        }
                      },
                      onLongPress: () =>
                          setStateDialog(() => tempFilterMonth = null),
                    ),
                    ListTile(
                      title: Text(
                        tempFilterYear == null
                            ? 'Filtrar por Ano'
                            : 'Ano: ${tempFilterYear!.year}',
                      ),
                      trailing: const Icon(Icons.calendar_view_month),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: tempFilterYear ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setStateDialog(() => tempFilterYear = date);
                        }
                      },
                      onLongPress: () =>
                          setStateDialog(() => tempFilterYear = null),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      filterEntrada = false;
                      filterSaida = false;
                      filterDay = null;
                      filterMonth = null;
                      filterYear = null;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Limpar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filterEntrada = tempFilterEntrada;
                      filterSaida = tempFilterSaida;
                      filterDay = tempFilterDay;
                      filterMonth = tempFilterMonth;
                      filterYear = tempFilterYear;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Aplicar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
