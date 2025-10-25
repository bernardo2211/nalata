import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'telas/login_tela.dart';
import 'telas/tela_cliente.dart';
import 'telas/tela_atendente.dart';

import 'telas/tela_carrinho.dart';
import 'telas/tela_cliente_inicial.dart';
import 'telas/tela_copao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LataBarApp());
}

class LataBarApp extends StatelessWidget {
  const LataBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lata Bar',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // 🔹 alterna automaticamente
      theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.amber,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/telaclienteinicial': (context) => const TelaClienteInicial(),
        '/login': (context) => const LoginTela(),
        '/cliente': (context) => const TelaCliente(),
        '/copao': (context) => const TelaCopao(),
        '/carrinho': (context) => const TelaCarrinho(),
        '/atendente': (context) => const TelaAtendente(),
      }
    );
  }
}
