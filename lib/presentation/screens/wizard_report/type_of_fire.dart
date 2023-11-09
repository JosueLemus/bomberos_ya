import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/config/theme/text_styles.dart';
import 'package:flutter/material.dart';

class TypeOfFire extends StatelessWidget {
  final Function goToNextPage;
  TypeOfFire({super.key, required this.goToNextPage});

  final List<String> fireTypes = [
    "Fuego 1",
    "Fuego 2",
    "Fuego 3",
    "Fuego 4",
    "Fuego 5 Fuego 5 Fuego 5 Fuego 5",
    "Fuego 6",
  ];

  @override
  Widget build(BuildContext context) {
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
              itemCount: fireTypes.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: ()=>goToNextPage(),
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
                          child: Image.network(
                            'https://i.pinimg.com/originals/30/8d/79/308d795c3cac0f8f16610f53df4e1005.jpg',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                fireTypes[index],
                                style: TextStyles.regularSecondaryMediumTextStyle,
                                maxLines: 2,
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
