import 'dart:convert';

class ProdutoModel {
  int id;
  String imagem;
  String nome;
  double preco;
  String peso;
  String pascoa;

  ProdutoModel(
      {required this.id,
      required this.imagem,
      required this.nome,
      required this.preco,
      required this.peso,
      required this.pascoa});

  factory ProdutoModel.fromJson(Map<String, dynamic> json) {
    return ProdutoModel(
      id: json['id'],
      imagem: json['imagem'],
      nome: json['nome'],
      preco: json['preco'],
      peso: json['peso'],
      pascoa: json['pascoa'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'imagem': imagem,
        'nome': nome,
        'preco': preco,
        'peso': peso,
        'pascoa': pascoa,
      };

  static Map<String, dynamic> toMap(ProdutoModel produto) => {
        'id': produto.id,
        'imagem': produto.imagem,
        'nome': produto.nome,
        'preco': produto.preco,
        'peso': produto.peso,
        'pascoa': produto.pascoa,
      };

  static String encode(List<ProdutoModel> produtos) => json.encode(
        produtos
            .map<Map<String, dynamic>>((produto) => ProdutoModel.toMap(produto))
            .toList(),
      );

  static List<ProdutoModel> decode(String produto) =>
      (json.decode(produto) as List<dynamic>)
          .map<ProdutoModel>((item) => ProdutoModel.fromJson(item))
          .toList();
}
