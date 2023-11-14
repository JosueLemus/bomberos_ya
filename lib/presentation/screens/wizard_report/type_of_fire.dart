import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/config/theme/text_styles.dart';
import 'package:bomberos_ya/presentation/providers/simple_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeOfFire extends ConsumerWidget {
  final Function goToNextPage;
  const TypeOfFire({super.key, required this.goToNextPage});

  @override
  Widget build(BuildContext context, ref) {
    final provider = ref.watch(simpleReportProvider);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('Selecciona el tipo de incendio',
              style: TextStyles.boldSecondaryLargeTextStyle),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: provider.fireTypes.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    provider.selectedType = provider.fireTypes[index];
                    goToNextPage();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryText.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                provider.fireTypes[index].imageUrl,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: ((context, error, stackTrace) {
                                  // TODO: Add image
                                  return Container(
                                    color: Colors.red,
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                provider.fireTypes[index].nombre,
                                style:
                                    TextStyles.regularSecondarySmallTextStyle,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
