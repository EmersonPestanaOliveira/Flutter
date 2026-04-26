import 'package:flutter_test/flutter_test.dart';
import 'package:gabriel_clone/core/di/injection_container.dart';
import 'package:gabriel_clone/main.dart';

void main() {
  testWidgets('opens app directly on home', (tester) async {
    await configureDependencies();
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Gabriel Clone'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}