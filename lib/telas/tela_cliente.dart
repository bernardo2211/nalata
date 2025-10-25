import 'package:flutter/material.dart';

class TelaCliente extends StatefulWidget {
  const TelaCliente({super.key});

  @override
  State<TelaCliente> createState() => _TelaClienteState();
}

class _TelaClienteState extends State<TelaCliente> {
  final Map<String, double> itens = {
    'Skol': 7,
    'Brahma': 8,
    'Heineken': 10,
    'Coca-Cola': 6,
    'Sprite': 6,
    'Guaraná': 6,
    'Caipirinha na lata (500ml)': 20,
    'Mojito rápido (500ml)': 20,
    'Gim no freio (500ml)': 20,
    'Água com gás': 3,
    'Água sem gás': 3,
  };

  final Map<String, String> imagens = {
    'Skol': 'https://carrefourbrfood.vtexassets.com/arquivos/ids/107629977/cerveja-skol-pilsen-lata-350ml-1.jpg ',
    'Brahma': 'https://mercantilatacado.vtexassets.com/arquivos/ids/168508/65391b486a2a15a1bb6c1b6f.jpg',
    'Heineken': 'https://acdn-us.mitiendanube.com/stores/001/043/122/products/23747001-5ce41b06762fdca44117267638083172-480-0.jpg',
    'Coca-Cola': 'https://zaffari.vtexassets.com/arquivos/ids/283217/1007841-00.jpg',
    'Sprite': 'https://andinacocacola.vtexassets.com/arquivos/ids/158586/Sprite-Original.jpg',
    'Guaraná': 'https://img.cdndsgni.com/preview/10000394.jpg',
    'Caipirinha na lata (500ml)': 'https://img.myloview.com.br/adesivos/suco-de-limao-em-copo-de-plastico-700-93884749.jpg',
    'Mojito rápido (500ml)': 'https://img.freepik.com/fotos-premium/coquetel-de-mojito-em-copo-de-plastico-com-tubo_711700-8018.jpg',
    'Gim no freio (500ml)': 'https://cdn.prod.website-files.com/611c4ebafe616f22a8ccfe82/661d4f5304de3614068db139_654a51b137fa892e9e343f39_Illa%20Mare_drinks_agosto23_DM%20(205).jpg%20(1).jpg',
    'Água com gás': 'https://carrefourbrfood.vtexassets.com/arquivos/ids/18904682/agua-mineral-com-gas-crystal-500ml-1.jpg',
    'Água sem gás': 'https://carrefourbrfood.vtexassets.com/arquivos/ids/18904684/agua-mineral-sem-gas-crystal-500ml-1.jpg?',
  };

  final Map<String, int> carrinho = {};
  final Map<String, double> itensCarrinho = {};

  void adicionarAoCarrinho(String item) {
    setState(() {
      carrinho[item] = (carrinho[item] ?? 0) + 1;
      itensCarrinho[item] = itens[item]!;
    });
  }

  double get total =>
      carrinho.entries.fold(0, (soma, item) => soma + (itensCarrinho[item.key]! * item.value));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Monte seu Pedido ',style: TextStyle(color: Color.fromARGB(255, 249, 193, 20)),),
        actions: [
          // Botão do carrinho no AppBar
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () async {
              final resultado = await Navigator.pushNamed(
                context,
                '/carrinho',
                arguments: {
                  'carrinho': carrinho,
                  'itens': itensCarrinho,
                },
              ) as Map<String, dynamic>?;

              if (resultado != null) {
                setState(() {
                  carrinho
                    ..clear()
                    ..addAll(Map<String, int>.from(resultado['carrinho'] ?? {}));
                  itensCarrinho
                    ..clear()
                    ..addAll(Map<String, double>.from(resultado['itens'] ?? {}));
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: itens.keys.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 7,
                  crossAxisSpacing: 9,
                  childAspectRatio: 0.5,
                ),
                itemBuilder: (context, index) {
                  final bebida = itens.keys.elementAt(index);
                  final preco = itens[bebida]!;
                  final imagemUrl = imagens[bebida] ??
                      'https://via.placeholder.com/150';

                  return GestureDetector(
                    onTap: () => adicionarAoCarrinho(bebida),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 115, // diminui a altura da imagem
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.network(
                                imagemUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bebida,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('R\$ $preco'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => adicionarAoCarrinho(bebida),
                            child: const Text('Adicionar'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 36),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Botão para ir montar o Copão
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final resultado = await Navigator.pushNamed(
                    context,
                    '/copao',
                    arguments: {
                      'carrinho': carrinho,
                      'itens': itensCarrinho,
                    },
                  ) as Map<String, dynamic>?;

                  if (resultado != null) {
                    setState(() {
                      carrinho
                        ..clear()
                        ..addAll(Map<String, int>.from(resultado['carrinho'] ?? {}));
                      itensCarrinho
                        ..clear()
                        ..addAll(Map<String, double>.from(resultado['itens'] ?? {}));
                    });
                  }
                },
                icon: const Icon(Icons.local_drink),
                label: const Text('Monte seu Copão'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Total: R\$ ${total.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
