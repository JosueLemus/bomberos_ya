import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/presentation/providers/simple_report_provider.dart';
import 'package:bomberos_ya/presentation/screens/wizard_report/add_images_screen.dart';
import 'package:bomberos_ya/presentation/screens/wizard_report/type_of_fire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'comment_screen.dart';

class SimpleReportScreen extends ConsumerStatefulWidget {
  const SimpleReportScreen({super.key});

  @override
  SimpleReportScreenState createState() => SimpleReportScreenState();
}

class SimpleReportScreenState extends ConsumerState<SimpleReportScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final int _totalPages = 3;
  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(simpleReportProvider);
    return Stack(
      children: [
        Scaffold(
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
                    TypeOfFire(goToNextPage: nextPage),
                    CommentsScreen(goToNextPage: nextPage),
                    const AddImagesScreen()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_totalPages, (index) {
                    return Container(
                      width: 15.0,
                      height: 15.0,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? AppColors.primaryColor
                            : AppColors.secondaryText.withOpacity(0.7),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        if(provider.isLoading)Expanded(
            child: Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        ))
      ],
    );
  }
}
