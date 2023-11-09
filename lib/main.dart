import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WizardPage(),
    );
  }
}

class WizardPage extends StatefulWidget {
  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int _totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wizard PageView"),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                // Pantalla 1
                Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text("Página 1", style: TextStyle(fontSize: 24)),
                  ),
                ),
                // Pantalla 2
                Container(
                  color: Colors.green,
                  child: Center(
                    child: Text("Página 2", style: TextStyle(fontSize: 24)),
                  ),
                ),
                // Pantalla 3
                Container(
                  color: Colors.orange,
                  child: Center(
                    child: Text("Página 3", style: TextStyle(fontSize: 24)),
                ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPages, (index) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),

          //   Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       if (_currentPage > 0)
          //         TextButton(
          //           onPressed: () {
          //             _pageController.previousPage(
          //               duration: Duration(milliseconds: 500),
          //               curve: Curves.ease,
          //             );
          //           },
          //           child: Text("Anterior"),
          //         )
          //       else
          //         Container(), // Para ocupar espacio, pero estar invisible

          //       Text("Página $_currentPage de $_totalPages"),

          //       if (_currentPage < _totalPages - 1)
          //         TextButton(
          //           onPressed: () {
          //             _pageController.nextPage(
          //               duration: Duration(milliseconds: 500),
          //               curve: Curves.ease,
          //             );
          //           },
          //           child: Text("Siguiente"),
          //         )
          //       else
          //         Container(), // Para ocupar espacio, pero estar invisible
          //     ],
          //   ),
          // ),
        
        ],
      ),
    );
  }
}
