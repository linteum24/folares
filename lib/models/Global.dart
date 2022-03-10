// ignore_for_file: file_names

import 'package:encomendas/models/produto_fabrica.dart';

class Global {
  static List<ProdutosF> stackDuplicates(List<ProdutosF> items) {
    Map<String, ProdutosF> uniqueItems = {};

    for (var item in items) {
      final key = '${item.id}-${item.nome}';

      (uniqueItems[key] == null)
          ? uniqueItems[key] = item
          : uniqueItems[key]?.quantidade += item.quantidade;
    }

    return uniqueItems.values.toList();
  }
}
