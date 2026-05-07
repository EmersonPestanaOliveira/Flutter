import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/network/network_connection_monitor.dart';
import 'package:gabriel_clone/core/widgets/network_status_banner.dart';

class TestNetworkConnectionMonitor extends ChangeNotifier
    implements NetworkConnectionMonitor {
  TestNetworkConnectionMonitor(this._status);

  NetworkConnectionStatus _status;

  @override
  NetworkConnectionStatus get status => _status;

  set status(NetworkConnectionStatus status) {
    _status = status;
    notifyListeners();
  }

  @override
  VoidCallback? onBackOnline;

  @override
  Future<void> checkNow() async {}
}

void main() {
  Widget buildSubject(TestNetworkConnectionMonitor monitor) {
    return MaterialApp(
      home: Scaffold(
        body: NetworkStatusBanner(
          monitor: monitor,
          child: const Text('conteudo'),
        ),
      ),
    );
  }

  testWidgets('exibe apenas o conteudo quando a conexao esta online', (
    tester,
  ) async {
    final monitor = TestNetworkConnectionMonitor(NetworkConnectionStatus.online);

    await tester.pumpWidget(buildSubject(monitor));

    expect(find.text('conteudo'), findsOneWidget);
    expect(find.textContaining('Sem conexao'), findsNothing);
    expect(find.textContaining('Conexao instavel'), findsNothing);
  });

  testWidgets('exibe banner de sem internet quando status e offline', (
    tester,
  ) async {
    final monitor = TestNetworkConnectionMonitor(
      NetworkConnectionStatus.offline,
    );

    await tester.pumpWidget(buildSubject(monitor));

    expect(
      find.text('Sem conexao com a internet. Algumas funcoes podem falhar.'),
      findsOneWidget,
    );
    expect(find.text('conteudo'), findsOneWidget);
  });

  testWidgets('exibe banner de conexao ruim quando status e poor', (
    tester,
  ) async {
    final monitor = TestNetworkConnectionMonitor(NetworkConnectionStatus.poor);

    await tester.pumpWidget(buildSubject(monitor));

    expect(
      find.text('Conexao instavel. O app pode demorar para responder.'),
      findsOneWidget,
    );
  });

  testWidgets('atualiza banner quando o monitor notifica mudanca', (
    tester,
  ) async {
    final monitor = TestNetworkConnectionMonitor(NetworkConnectionStatus.online);

    await tester.pumpWidget(buildSubject(monitor));
    expect(find.textContaining('Sem conexao'), findsNothing);

    monitor.status = NetworkConnectionStatus.offline;
    await tester.pump();

    expect(
      find.text('Sem conexao com a internet. Algumas funcoes podem falhar.'),
      findsOneWidget,
    );
  });
}
