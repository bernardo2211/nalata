import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginTela extends StatefulWidget {
  const LoginTela({super.key});

  @override
  State<LoginTela> createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  bool carregando = false;

  Future<void> _login() async {
    setState(() => carregando = true);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: senhaCtrl.text,
      );

      // Se for atendente, redireciona
      if (cred.user!.email!.contains('atendente')) {
        Navigator.pushReplacementNamed(context, '/atendente');
      } else {
        Navigator.pushReplacementNamed(context, '/telaclienteinicial');
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro: ${e.message}')));
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Login - Lata Bar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'E-mail')),
                  TextField(controller: senhaCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Senha')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: carregando ? null : _login,
                    child: carregando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
