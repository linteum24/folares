import 'package:encomendas/models/produto_fabrica.dart';
import 'package:flutter/widgets.dart';

class ProdutosProvider with ChangeNotifier {
  List<ProdutosF> lst = [];

  add(int id, String imagem, String nome) {
    var contain = lst.where((element) => element.id == id);
    if (lst.isEmpty || contain.isEmpty) {
      lst.add(ProdutosF(id: id, imagem: imagem, nome: nome, quantidade: 1));
      notifyListeners();
    } else {
      lst[lst.indexWhere((element) => element.id == id)] = ProdutosF(
          id: id,
          imagem: imagem,
          nome: nome,
          quantidade:
              lst[lst.indexWhere((element) => element.id == id)].quantidade +
                  1);
      notifyListeners();
    }
  }

  del(String nm) {
    lst.removeWhere((item) => item.nome == nm);
    notifyListeners();
  }

  delAll() {
    lst = [];
    notifyListeners();
  }
}
