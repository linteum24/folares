class ProdutosF {
  ProdutosF(
      {required this.id,
      required this.imagem,
      required this.nome,
      required this.quantidade});

  int id;
  String imagem;
  String nome;
  int quantidade;

  factory ProdutosF.fromJson(Map<String, dynamic> json) {
    return ProdutosF(
        id: json['id'] as int,
        imagem: json['imagem'] as String,
        nome: json['nome'] as String,
        quantidade: json['quantidade'] as int);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'imagem': imagem, 'nome': nome, 'quantidade': quantidade};
}
