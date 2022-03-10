import 'package:encomendas/date_picker/extra/color.dart';
import 'package:encomendas/widget/produtos_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProdutoItem extends StatelessWidget {
  const ProdutoItem(
      {Key? key,
      required this.screenSize,
      required this.id,
      required this.imagem,
      required this.nome})
      : super(key: key);

  final Size screenSize;
  final int id;
  final String imagem, nome;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: screenSize.height * 0.5,
      width: screenSize.width * 0.3,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 0),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ExtendedImage.network(
                imagem,
                width: screenSize.width * 0.3,
                height: screenSize.height * 0.12,
                fit: BoxFit.contain,
                cache: true,
              )),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(nome,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.height * 0.018)),
          ),
          Consumer<ProdutosProvider>(
            builder: (context, value, child) => InkWell(
              onTap: () {
                value.add(id, imagem, nome);
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                    height: screenSize.height * 0.06,
                    width: screenSize.width * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF7D5A50)),
                    child: const Center(
                      child: Text(
                        "Adicionar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
