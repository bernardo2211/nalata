import 'package:flutter/material.dart';

class TelaClienteInicial extends StatelessWidget {
  const TelaClienteInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usando SafeArea para tablets com notch
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo / título
              const SizedBox(height: 12),
              const Text(
                'Na Lata Bar',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 249, 193, 20),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Autoatendimento',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade300,
                ),
              ),

              const SizedBox(height: 28),

              // Bloco explicativo
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Bem-vindo! Toque em "Iniciar Pedido" para escolher suas bebidas. '
                    'Ao finalizar, informe seu nome e CPF para concluir o pedido.',
                    style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 255, 255, 255)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const Spacer(),

              // Botão principal grande
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton(
                  onPressed: () {
                    // Navega para a tela de escolher bebidas (rota: /cliente)
                    Navigator.pushNamed(context, '/cliente');
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Iniciar Pedido'),
                ),
              ),

              const SizedBox(height: 16),

              // Botão menor para ajuda / informações
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Como funciona'),
                      content: const Text(
                        '1) Escolha as bebidas e adicione ao carrinho.\n'
                        '2) Ao finalizar, informe seu nome e CPF.\n'
                        '3) O pedido será enviado ao atendente.\n\n'
                        'Se precisar, peça ajuda ao atendente.',
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Fechar'))
                      ],
                    ),
                  );
                },
                child: const Text('Como funciona'),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
