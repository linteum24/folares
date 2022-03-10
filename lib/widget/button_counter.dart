import 'dart:convert';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:encomendas/date_picker/extra/color.dart';
import 'package:encomendas/models/Global.dart';
import 'package:encomendas/models/produto_fabrica.dart';
import 'package:encomendas/widget/carrinho_item.dart';
import 'package:encomendas/widget/produtos_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BotaoCounter extends StatefulWidget {
  final String count;
  const BotaoCounter({
    Key? key,
    required this.count,
  }) : super(key: key);
  @override
  _BotaoCounterState createState() => _BotaoCounterState();
}

class _BotaoCounterState extends State<BotaoCounter> {
  final dt = DateTime.now();
  String _d1 = '';
  String _d2 = '';
  String _t1 = '';

  TextEditingController nomeController = TextEditingController();
  TextEditingController telController = TextEditingController();

  Future _criarPedido(List<ProdutosF> list) async {
    final response = await http.post(
      Uri.parse("https://folares2022.000webhostapp.com/api/add.php"),
      body: {
        'nome': nomeController.text.toString(),
        'tel': telController.text.toString(),
        'lista': json.encode(list),
        'data': _d1,
        'hora': _t1,
      },
    );
    if (response.statusCode == 200) {
      debugPrint(response.body.toString());
      const snackBar = SnackBar(content: Text('Pedido efetuado!'));

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      debugPrint("Erro! Tente outra vez! Código: ${response.statusCode}");
    }
  }

  //scrollcontroller
  late ScrollController _scrollController;

  _scrollListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _d2 = DateFormat('dd MMMM yyyy').format(dt);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ClipRRect(
        child: Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFFE5B299),
                  Color(0xFFB4846C),
                  Color(0xFF7D5A50),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
            width: double.infinity,
            height: screenSize.height * 0.08,
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) => Container(
                      height: screenSize.height * 0.95,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      child: SafeArea(
                          top: false,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Consumer<ProdutosProvider>(
                                    builder: (context, value, child) =>
                                        SizedBox(
                                          height: screenSize.height * 0.05,
                                          width: double.infinity,
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: value.lst.length,
                                            itemBuilder: (context, index) {
                                              return Dismissible(
                                                key: UniqueKey(),
                                                direction:
                                                    DismissDirection.horizontal,
                                                background: Container(
                                                  color: Colors.red,
                                                ),
                                                onDismissed: (direction) {
                                                  value.del(
                                                      value.lst[index].nome);
                                                },
                                                child: CarrinhoItem(
                                                  screenSize: screenSize,
                                                  id: value.lst[index].id,
                                                  imagem:
                                                      value.lst[index].imagem,
                                                  nome: value.lst[index].nome,
                                                  quantidade: value
                                                      .lst[index].quantidade,
                                                ),
                                              );
                                            },
                                          ),
                                        )),
                                Column(children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: TextField(
                                        controller: nomeController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Nome',
                                        ),
                                      )),
                                  const SizedBox(height: 10),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: TextField(
                                        controller: telController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Telemóvel',
                                        ),
                                      )),
                                  const SizedBox(height: 5),
                                  _datePicker(),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                      height: screenSize.height * 0.08,
                                      width: double.infinity,
                                      child: buttonPedir(context, screenSize))
                                ]),
                              ]))),
                );
              },
              child: Text('Ver Pedido (' + widget.count + ')'),
            )),
      ],
    ));
  }

  Widget buttonPedir(BuildContext context, var screenSize) {
    List<ProdutosF> list =
        Provider.of<ProdutosProvider>(context, listen: false).lst;
    return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFE5B299),
                      Color(0xFFB4846C),
                      Color(0xFF7D5A50),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
                width: double.infinity,
                height: screenSize.height * 0.08,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    await _criarPedido(list);

                    // Remove all existing routes until the Home.dart, then rebuild Home.
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                    Provider.of<ProdutosProvider>(context, listen: false)
                        .delAll();
                  },
                  child: const Text('Confirmar Pedido'),
                )),
          ],
        ));
  }

  Widget _datePicker() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Column(children: [
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              'Data: $_d2 Hora: $_t1',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
        DateTimePicker(
          datePickerTitle: 'Escolher data',
          initialSelectedDate: dt,
          endDate: dt.add(const Duration(days: 90)),
          type: DateTimePickerType.Both,
          is24h: true,
          numberOfWeeksToDisplay: 2,
          timeOutOfRangeError: 'Sem horas disponíveis!',
          timePickerTitle: 'Escolher hora',
          startTime: DateTime(dt.year, dt.month, dt.day, 10),
          endTime: DateTime(dt.year, dt.month, dt.day, 22),
          timeInterval: const Duration(minutes: 15),
          onTimeChanged: (time) {
            stateSetter(() {
              _t1 = DateFormat('HH:mm').format(time);
            });
          },
          onDateChanged: (date) {
            stateSetter(() {
              _d1 = DateFormat('dd-MM-yyyy').format(date);
              _d2 = DateFormat('dd MMMM yyyy').format(date);
            });
          },
        )
      ]);
    });
  }
}
