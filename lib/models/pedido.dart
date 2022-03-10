import 'dart:convert';
import 'package:encomendas/models/produto_fabrica.dart';

class PedidosF {
  int id;
  String nome;
  String tel;
  List<ProdutosF> lista;
  String data;
  String hora;

  PedidosF(
      {required this.id,
      required this.nome,
      required this.tel,
      required this.lista,
      required this.data,
      required this.hora});

  factory PedidosF.fromJson(Map<dynamic, dynamic> json) {
    var list = jsonDecode(json['lista']) as List;
    List<ProdutosF> itemsList = list.map((i) => ProdutosF.fromJson(i)).toList();
    return PedidosF(
        id: json['id'] as int,
        nome: json['nome'] as String,
        tel: json['tel'] as String,
        lista: itemsList,
        data: json['dt'] as String,
        hora: json['hora'] as String);
  }

  //List<ProdutosF>.from(jsonDecode(json['lista']).map((model) => ProdutosF.fromJson(model)))

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'tel': tel,
        'lista': lista,
        'data': data,
        'hora': hora
      };
}
