// ignore_for_file: file_names

import 'dart:convert';
import 'package:encomendas/date_picker/extra/color.dart';
import 'package:encomendas/models/pedido.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../date_picker/date_picker_widget.dart';
import 'package:http/http.dart' as http;
import '../widget/responsive.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({Key? key}) : super(key: key);

  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
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
                          debugPrint(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return Padding(
                            padding: EdgeInsets.all(screenSize.height * 0.01),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  PedidosF pedidosF = snapshot.data[index];

                                  StringBuffer sb = StringBuffer();
                                  for (var item in pedidosF.lista) {
                                    sb.write(item.quantidade.toString() +
                                        ' ' +
                                        item.nome +
                                        "\n");
                                  }
                                  String stringList = sb.toString();

                                  return Container(
                                      margin: EdgeInsets.all(
                                          screenSize.height * 0.03),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                offset: const Offset(0, 0),
                                                blurRadius: 1,
                                                spreadRadius: 1)
                                          ]),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            minHeight: screenSize.height * 0.2,
                                            maxHeight: screenSize.height * 0.3),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFF7D5A50),
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    15.0))),
                                                child: Column(children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10,
                                                              left: 10),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                  'Nome',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenSize.height *
                                                                              0.025)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                  'Hora',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenSize.height *
                                                                              0.025)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                  'Telemóvel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenSize.height *
                                                                              0.025)),
                                                            ),
                                                          ])),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10, right: 10),
                                                      child: Divider(
                                                          height: 1,
                                                          color: Colors.white)),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                  pedidosF.nome,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenSize.height *
                                                                              0.02)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                  pedidosF.hora,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenSize.height *
                                                                              0.02)),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                  pedidosF.tel,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          screenSize.height *
                                                                              0.02)),
                                                            ),
                                                          ])),
                                                ])),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                stringList,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenSize.height *
                                                            0.025),
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                                }));
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
                          debugPrint(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return Padding(
                            padding: EdgeInsets.all(screenSize.height * 0.01),
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  PedidosF pedidosF = snapshot.data[index];

                                  StringBuffer sb = StringBuffer();
                                  for (var item in pedidosF.lista) {
                                    sb.write(item.quantidade.toString() +
                                        ' ' +
                                        item.nome +
                                        "\n");
                                  }
                                  String stringList = sb.toString();

                                  return Container(
                                    margin: const EdgeInsets.all(10),
                                    height: screenSize.height * 0.2,
                                    width: screenSize.width * 0.3,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              offset: const Offset(0, 0),
                                              blurRadius: 1,
                                              spreadRadius: 1)
                                        ]),
                                    child: Column(
                                      children: [
                                        Container(
                                            decoration: const BoxDecoration(
                                                color: AppColors.custom_color,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15.0),
                                                    topRight:
                                                        Radius.circular(15.0))),
                                            child: Column(children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text('Nome',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: screenSize
                                                                      .height *
                                                                  0.025)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text('Hora',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: screenSize
                                                                      .height *
                                                                  0.025)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text('Telemóvel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: screenSize
                                                                      .height *
                                                                  0.025)),
                                                    ),
                                                  ]),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(pedidosF.nome,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: screenSize
                                                                      .height *
                                                                  0.02)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(pedidosF.hora,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: screenSize
                                                                      .height *
                                                                  0.02)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(pedidosF.tel,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: screenSize
                                                                      .height *
                                                                  0.02)),
                                                    ),
                                                  ]),
                                            ])),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            stringList,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    screenSize.height * 0.025),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }));
                      },
                    ),
                  ],
                )));
  }
}
