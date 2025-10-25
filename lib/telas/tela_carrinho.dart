import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({super.key});

  @override
  State<TelaCarrinho> createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  final nomeCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();

  Future<void> enviarPedido(
    Map<String, int> carrinho, Map<String, double> itens) async {
  final nome = nomeCtrl.text.trim();
  final cpf = cpfCtrl.text.trim();

  // 🔹 Verifica se os campos obrigatórios foram preenchidos
  if (nome.isEmpty || cpf.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preencha o nome e o CPF antes de enviar o pedido.',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final total = carrinho.entries.fold<int>(
    0,
    (soma, e) => soma + ((itens[e.key] ?? 0) * e.value).round(),
  );

  await FirebaseFirestore.instance.collection('pedidos').add({
    'nome': nome,
    'cpf': cpf,
    'itens': carrinho,
    'total': total,
    'status': 'pendente',
    'timestamp': FieldValue.serverTimestamp(),
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text('Pedido enviado com sucesso!'),
        ],
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );

  // 🔹 Limpa o carrinho e zera o total
  carrinho.clear();
  itens.clear();
  nomeCtrl.clear();
  cpfCtrl.clear();

  // Retorna o carrinho limpo para a tela anterior
  Navigator.pop(context, {
    'carrinho': carrinho,
    'itens': itens,
  });
}


  void cancelarPedido(Map<String, int> carrinho, Map<String, double> itens) {
    carrinho.clear();
    itens.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido cancelado.')),
    );

    Navigator.pop(context, {
      'carrinho': carrinho,
      'itens': itens,
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final carrinho = Map<String, int>.from(args['carrinho'] ?? {});
    final itens = Map<String, double>.from(args['itens'] ?? {});

    int calcularTotal() {
      return carrinho.entries.fold<int>(
        0,
        (soma, e) => soma + ((itens[e.key] ?? 0) * (carrinho[e.key] ?? 0)).round(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho de Pedidos')),
      body: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: cpfCtrl,
                  decoration: const InputDecoration(labelText: 'CPF'),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView(
                    children: carrinho.entries.map((e) {
                      final precoItem =
                          ((itens[e.key] ?? 0) * (carrinho[e.key] ?? 0)).round();
                      return Card(
                        child: ListTile(
                          title: Text(e.key),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    if ((carrinho[e.key] ?? 0) > 1) {
                                      carrinho[e.key] = (carrinho[e.key] ?? 1) - 1;
                                    } else {
                                      carrinho.remove(e.key);
                                    }
                                  });
                                },
                              ),
                              Text('x${e.value}', style: const TextStyle(fontSize: 18)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    carrinho[e.key] = (carrinho[e.key] ?? 0) + 1;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              Text('R\$ $precoItem'),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Total: R\$ ${calcularTotal()}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

               Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: carrinho.isEmpty
                            ? null
                            : () => enviarPedido(carrinho, itens),
                        icon: const Icon(Icons.send, size: 20),
                        label: const Text('Enviar Pedido', overflow: TextOverflow.ellipsis),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: carrinho.isEmpty
                            ? null
                            : () => cancelarPedido(carrinho, itens),
                        icon: const Icon(Icons.cancel, size: 20),
                        label: const Text('Cancelar Pedido', overflow: TextOverflow.ellipsis),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
