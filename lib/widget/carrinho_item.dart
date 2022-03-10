import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CarrinhoItem extends StatelessWidget {
  const CarrinhoItem(
      {Key? key,
      required this.screenSize,
      required this.id,
      required this.imagem,
      required this.nome,
      required this.quantidade})
      : super(key: key);

  final Size screenSize;
  final int id;
  final String imagem, nome;
  final int quantidade;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: screenSize.height * 0.15,
      width: screenSize.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.blue[200]!.withOpacity(0.3),
                offset: const Offset(0, 0),
                blurRadius: 3,
                spreadRadius: 3)
          ]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ExtendedImage.network(
              imagem,
              width: screenSize.width * 0.3,
              height: screenSize.height * 0.13,
              fit: BoxFit.contain,
              cache: true,
            )),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            nome,
            style: const TextStyle(fontSize: 22),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            quantidade.toString(),
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ]),
    );
  }
}
