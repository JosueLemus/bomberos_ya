import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/config/theme/text_styles.dart';
import 'package:bomberos_ya/presentation/providers/simple_report_provider.dart';
import 'package:bomberos_ya/presentation/widgets/fire_type_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeOfFire extends ConsumerWidget {
  const TypeOfFire({super.key});

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
          child: provider.noDataFound
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: TextButton(
                        onPressed: () => provider.getFireTypes(),
                        child: const Text(
                          "Tipos de incendio no encontrados. Toca para volver a intentar.",
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: provider.fireTypes.length,
                    itemBuilder: (context, index) {
                      return FireTypeCard(
                          isSelected: provider.selectedType ==
                              provider.fireTypes[index].id,
                          fireType: provider.fireTypes[index],
                          onTap: () {
                            final selectedType = provider.fireTypes[index];
                            provider.updateSelectedType(selectedType);
                            // provider.goToNextPage();
                          });
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
