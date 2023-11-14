import 'package:bomberos_ya/config/helpers/local_storage_util.dart';
import 'package:bomberos_ya/config/theme/text_styles.dart';
import 'package:bomberos_ya/presentation/providers/simple_report_provider.dart';
import 'package:bomberos_ya/presentation/widgets/fire_type_card.dart';
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
                return FireTypeCard(
                    fireType: provider.fireTypes[index],
                    onTap: () {
                      final selectedType = provider.fireTypes[index];
                      provider.selectedType = selectedType;
                      goToNextPage();
                      LocalStorageUtil.saveLocalData(
                          selectedType.id, KeyTypes.selectedType);
                    });
              },
            ),
          ),
        ),
      ],
    );
  }
}
