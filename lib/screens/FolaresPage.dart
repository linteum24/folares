// ignore_for_file: file_names

import 'dart:convert';
import 'package:encomendas/date_picker/extra/color.dart';
import 'package:encomendas/models/pedido.dart';
import 'package:encomendas/models/produto_fabrica.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../date_picker/date_picker_widget.dart';
import 'package:http/http.dart' as http;
import '../models/Global.dart';
import '../widget/responsive.dart';

class FolaresPage extends StatefulWidget {
  const FolaresPage({Key? key}) : super(key: key);

  @override
  _FolaresPageState createState() => _FolaresPageState();
}

class _FolaresPageState extends State<FolaresPage> {
  final DatePickerController _controller = DatePickerController();
  late Future<List<PedidosF>> futurePedidos;

  String _selectedValue = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Future<List<PedidosF>> getPedidosList(String dt) async {
    http.Response response = await http.get(Uri.parse(
        "https://folares2022.000webhostapp.com/api/pedidos.php?data=" + dt));
    List pedidos = json.decode(response.body);
    return pedidos.map((json) => PedidosF.fromJson(json)).toList();
  }

  //scrollcontroller
  late ScrollController _scrollController;

  _scrollListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    futurePedidos = getPedidosList(_selectedValue);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size(screenSize.width, screenSize.height / 10),
            child: DatePicker(
              DateTime.now().subtract(const Duration(days: 2)),
              width: 60,
              height: 80,
              controller: _controller,
              initialSelectedDate: DateTime.now(),
              selectionColor: const Color(0xFF7D5A50),
              selectedTextColor: Colors.white,
              dayTextStyle: const TextStyle(color: Colors.white),
              monthTextStyle: const TextStyle(color: Colors.white),
              dateTextStyle: const TextStyle(color: Colors.white),
              onDateChange: (date) {
                setState(() {
                  _selectedValue = DateFormat('dd-MM-yyyy').format(date);
                  futurePedidos = getPedidosList(_selectedValue);
                });
              },
            )),
        body: ResponsiveWidget.isSmallScreen(context)
            ? SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<List<PedidosF>>(
                      future: futurePedidos,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          // ignore: avoid_print
                          print(snapshot.error);
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return _listFolares(snapshot, screenSize);
                      },
                    ),
                  ],
                ))
            : SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<List<PedidosF>>(
                      future: futurePedidos,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          // ignore: avoid_print
                          print(snapshot.error);
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return _listFolares(snapshot, screenSize);
                      },
                    ),
                  ],
                )));
  }

  Widget _listFolares(AsyncSnapshot snapshot, var screenSize) {
    List<PedidosF> pedidos = snapshot.data;
    List<ProdutosF> lista = [];
    for (int i = 0; i < pedidos.length; i++) {
      PedidosF pedidosF = snapshot.data[i];
      for (var item in pedidosF.lista) {
        lista.add(item);
      }
    }
    var listaf = Global.stackDuplicates(lista);

    StringBuffer sb = StringBuffer();
    for (var item in listaf) {
      sb.write("\n" + item.quantidade.toString() + " " + item.nome + "\n");
    }

    String stringList = sb.toString();

    return Center(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(stringList,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: screenSize.height * 0.02)),
    ));
  }
}
