// ignore_for_file: file_names

import 'dart:convert';
import 'package:encomendas/widget/button_counter.dart';
import 'package:encomendas/widget/produto_item.dart';
import 'package:encomendas/widget/responsive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/produto.dart';
import '../widget/produtos_provider.dart';

class EncomendaPage extends StatefulWidget {
  const EncomendaPage({Key? key}) : super(key: key);

  @override
  _EncomendaPageState createState() => _EncomendaPageState();
}

class _EncomendaPageState extends State<EncomendaPage> {
  //lista produtos
  Future<List<ProdutoModel>> getProdutosList() async {
    http.Response response = await http.get(
        Uri.parse("https://folares2022.000webhostapp.com/api/produtos.php"));
    List produtos = json.decode(response.body);
    return produtos.map((json) => ProdutoModel.fromJson(json)).toList();
  }

  //scrollcontroller
  late ScrollController _scrollController;

  _scrollListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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
            child: Consumer<ProdutosProvider>(builder: (context, value, child) {
              double sum = value.lst
                  .map((valor) => valor.quantidade)
                  .fold(0, (prev, amount) => prev + amount);

              return SizedBox(
                  height: screenSize.height * 0.07,
                  width: double.infinity,
                  child: BotaoCounter(
                    count: sum.toString(),
                  ));
            })),
        body: ResponsiveWidget.isSmallScreen(context)
            ? SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<List<ProdutoModel>>(
                      future: getProdutosList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          debugPrint(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                Center(child: CircularProgressIndicator())
                              ]);
                        }
                        return Padding(
                            padding: EdgeInsets.all(screenSize.height * 0.01),
                            child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 1,
                                        mainAxisSpacing: 1,
                                        childAspectRatio: 0.9),
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  ProdutoModel produto = snapshot.data[index];

                                  return ProdutoItem(
                                      screenSize: screenSize,
                                      id: produto.id,
                                      imagem: produto.imagem,
                                      nome: produto.nome);
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
                    FutureBuilder<List<ProdutoModel>>(
                      future: getProdutosList(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasError) {
                          debugPrint(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return SizedBox(
                            width: screenSize.width,
                            height: screenSize.height,
                            child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: Color(0xFF7D5A50),
                                ))),
                          );
                        }
                        return Padding(
                            padding: EdgeInsets.all(screenSize.height * 0.01),
                            child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 0.1,
                                        mainAxisSpacing: 0.1,
                                        childAspectRatio: 0.9),
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  ProdutoModel produto = snapshot.data[index];

                                  return ProdutoItem(
                                      screenSize: screenSize,
                                      id: produto.id,
                                      imagem: produto.imagem,
                                      nome: produto.nome);
                                }));
                      },
                    ),
                  ],
                )));
  }
}
