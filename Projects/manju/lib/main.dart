import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manju/agenda/ui/agenda_page.dart';
import 'package:manju/clients/data/clients_model.dart';
import 'package:manju/clients/ui/clients_page.dart';
import 'package:manju/clients/ui/clients_profile_page.dart';
import 'package:manju/commons/notification_service.dart';
import 'package:manju/financial/ui/financial_page.dart';
import 'package:manju/products/ui/products_page.dart';
import 'package:manju/screens/home_screen.dart';
import 'package:manju/screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/clients': (context) => const ClientsPage(),
        '/agenda': (context) => const AgendaPage(),
        '/products': (context) => const ProductsPage(),
        '/financial': (context) => const FinancialPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/clients_profile') {
          final client = settings.arguments as ClientModel;
          return MaterialPageRoute(
            builder: (context) => ClientsProfilePage(client: client),
          );
        }

        return null;
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
