import 'package:flutter/material.dart';

class TelaCopao extends StatefulWidget {
  const TelaCopao({super.key});

  @override
  State<TelaCopao> createState() => _TelaCopaoState();
}

class _TelaCopaoState extends State<TelaCopao> {
  String? bebidaSelecionada;
  String? energeticoSelecionado;
  String? geloSelecionado;

  double precoTotal = 0;

  final Map<String, double> copoes = {
    'Absolut': 30,
    'Jack Daniels': 30,
    'Smirnoff': 20,
    'White Horse': 30,
  };

  final List<String> energeticos = [
    'Maçã verde',
    'Abacaxi com hortelã',
    'Tradicional',
    'Coco com açaí',
    'Tropical',
    'Melancia',
    'Zero',
  ];

  final List<String> gelos = [
    'Sem sabor',
    'Coco',
    'Uva',
    'Morango',
    'Maçã verde',
  ];

  void atualizarPreco() {
    setState(() {
      precoTotal = bebidaSelecionada != null ? copoes[bebidaSelecionada]! : 0;
    });
  }

  void adicionarCopao(BuildContext context) {
    if (bebidaSelecionada == null ||
        energeticoSelecionado == null ||
        geloSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione todos os itens antes de adicionar!'),
        ),
      );
      return;
    }

    final nome =
        '$bebidaSelecionada + $energeticoSelecionado + gelo $geloSelecionado (700ml)';

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final carrinho = args['carrinho'] as Map<String, int>? ?? {};
    final itens = args['itens'] as Map<String, double>? ?? {};

    carrinho[nome] = (carrinho[nome] ?? 0) + 1;
    itens[nome] = precoTotal;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copão adicionado: $nome')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monte seu Copão 🍹')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Escolha a bebida alcoólica:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: bebidaSelecionada,
            isExpanded: true,
            hint: const Text('Selecione a bebida'),
            items: copoes.keys
                .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                .toList(),
            onChanged: (v) {
              setState(() => bebidaSelecionada = v);
              atualizarPreco();
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'Escolha o energético:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: energeticoSelecionado,
            isExpanded: true,
            hint: const Text('Selecione o energético'),
            items: energeticos
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => energeticoSelecionado = v),
          ),
          const SizedBox(height: 20),
          const Text(
            'Escolha o sabor do gelo:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: geloSelecionado,
            isExpanded: true,
            hint: const Text('Selecione o sabor do gelo'),
            items: gelos
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (v) => setState(() => geloSelecionado = v),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'Preço: R\$ ${precoTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => adicionarCopao(context),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar ao Pedido'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
