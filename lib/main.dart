import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Na Lata Bar',
      home: Scaffold(
        appBar: AppBar(title: const Text('Na Lata Bar')),
        body: const Center(child: Text('Firebase conectado com sucesso!')),
      ),
    );
  }
}
