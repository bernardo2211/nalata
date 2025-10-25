import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaAtendente extends StatefulWidget {
  const TelaAtendente({super.key});

  @override
  State<TelaAtendente> createState() => _TelaAtendenteState();
}

class _TelaAtendenteState extends State<TelaAtendente> {
  final Set<String> _emProducaoIds = {};

  Future<void> marcarEntregue(String docId, String nome) async {
    try {
      await FirebaseFirestore.instance
          .collection('pedidos')
          .doc(docId)
          .update({'status': 'entregue'});

      if (!mounted) return;

      setState(() {
        _emProducaoIds.remove(docId);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pedido de $nome marcado como entregue!'),
            duration: const Duration(seconds: 2),
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar pedido $nome: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> marcarEmProducao(String docId) async {
    setState(() => _emProducaoIds.add(docId));
    await FirebaseFirestore.instance
        .collection('pedidos')
        .doc(docId)
        .update({'status': 'em produção'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pedidos Recebidos',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          // Filtra apenas pendente ou em produção
          final pedidosVisiveis = docs.where((doc) {
            final status = doc['status'] ?? '';
            return status == 'pendente' || status == 'em produção';
          }).toList();

          if (pedidosVisiveis.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum pedido pendente.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: pedidosVisiveis.length,
            itemBuilder: (context, index) {
              final doc = pedidosVisiveis[index];
              final data = doc.data() as Map<String, dynamic>;

              final nome = data['nome'] ?? 'Cliente';
              final total = data['total'] ?? 0;
              final itens = (data['itens'] as Map)
                  .entries
                  .map((e) => '• ${e.key} x${e.value}')
                  .join('\n');

              final isEmProducao = _emProducaoIds.contains(doc.id);

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        itens,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const Divider(height: 20, thickness: 1),
                      Text(
                        'Total: R\$ ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed:
                                isEmProducao ? null : () => marcarEmProducao(doc.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: isEmProducao
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Em produção',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => marcarEntregue(doc.id, nome),
                            icon: const Icon(Icons.check_circle, size: 20),
                            label: const Text(
                              'Entregue',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
