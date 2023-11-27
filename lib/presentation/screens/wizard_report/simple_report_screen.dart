import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/config/theme/text_styles.dart';
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
  int currentPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
  // void

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(simpleReportProvider);
    if (mounted && currentPage != provider.currentPage) {
      _pageController.jumpToPage(provider.currentPage);
      currentPage = provider.currentPage;
    }
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
                  // physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: provider.setPage,
                  children: const [
                    TypeOfFire(),
                    CommentsScreen(),
                    AddImagesScreen()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32, left: 23, right: 23),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: provider.currentPage == 0
                            ? null
                            : provider.goToPreviousPage,
                        child: const Text("Anterior")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          width: 15.0,
                          height: 15.0,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: provider.currentPage == index
                                ? AppColors.primaryColor
                                : AppColors.secondaryText.withOpacity(0.7),
                          ),
                        );
                      }),
                    ),
                    TextButton(
                        onPressed: provider.currentPage == 2
                            ? null
                            : provider.goToNextPage,
                        child: const Text("Siguiente")),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (provider.isLoading)
          Material(
            color: Colors.transparent,
            child: Container(
              height: double.infinity,
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      provider.currentProcess,
                      style: const TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}
