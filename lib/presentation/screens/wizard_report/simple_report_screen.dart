import 'package:bomberos_ya/presentation/screens/wizard_report/add_images_screen.dart';
import 'package:bomberos_ya/presentation/screens/wizard_report/type_of_fire.dart';
import 'package:flutter/material.dart';

import 'comment_screen.dart';

class SimpleReportScreen extends StatefulWidget {
  const SimpleReportScreen({super.key});

  @override
  SimpleReportScreenState createState() => SimpleReportScreenState();
}

class SimpleReportScreenState extends State<SimpleReportScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar incendio"),
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
                TypeOfFire(),
                CommentsScreen(),
                AddImagesScreen()
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
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
