// ignore_for_file: file_names

import 'package:encomendas/date_picker/extra/color.dart';
import 'package:encomendas/screens/EncomendaPage.dart';
import 'package:encomendas/screens/FolaresPage.dart';
import 'package:encomendas/screens/PedidosPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Bottom Navigation
  late PageController _screens;
  var _bottomNavIndex = 1;

  @override
  void initState() {
    super.initState();
    //Pageview
    _screens = PageController(initialPage: 1);
  }

  void onTappedBar(int value) {
    setState(() {
      _bottomNavIndex = value;
    });
    _screens.animateToPage(value,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _screens,
              children: const <Widget>[
            PedidosPage(),
            EncomendaPage(),
            FolaresPage()
          ])),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: MediaQuery.of(context).size.height * 0.04,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page_outlined),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Adicionar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered_outlined),
            label: 'Folares',
          ),
        ],
        currentIndex: _bottomNavIndex,
        backgroundColor: const Color(0xFFB4846C),
        unselectedItemColor: const Color.fromRGBO(252, 236, 221, 0.8),
        selectedItemColor: Colors.white,
        onTap: onTappedBar,
      ),
    );
  }
}
