import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;

  final _pagesNameList = [
    "Fotos 4U",
    "En espera",
    "Agregar",
    "Mi contenido",
  ];

  final _pagesList = [
    Center(child: Text("Fotos 4U")),
    Center(child: Text("En espera")),
    Center(child: Text("Agregar")),
    Center(child: Text("Mi contenido")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pagesNameList[_currentPageIndex]),
        actions: [],
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pagesList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: _pagesNameList[0],
            icon: Icon(Icons.view_carousel),
          ),
          BottomNavigationBarItem(
            label: _pagesNameList[1],
            icon: Icon(Icons.query_builder),
          ),
          BottomNavigationBarItem(
            label: _pagesNameList[2],
            icon: Icon(Icons.photo_camera),
          ),
          BottomNavigationBarItem(
            label: _pagesNameList[3],
            icon: Icon(Icons.mobile_friendly),
          ),
        ],
      ),
    );
  }
}
