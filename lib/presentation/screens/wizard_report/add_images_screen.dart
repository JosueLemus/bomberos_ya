import 'dart:io';

import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/presentation/providers/simple_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/theme/text_styles.dart';

class AddImagesScreen extends ConsumerWidget {
  const AddImagesScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final provider = ref.watch(simpleReportProvider);
    Future<void> openCamera() async {
      final picker = ImagePicker();
      final image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 5);
      if (image != null) {
        provider.addImage(image.path);
      }
    }

    return Column(
      children: [
        Text(
          "Agrega imágenes de la situación (${provider.selectedImages.length} de ${provider.imageLimit})",
          style: TextStyles.boldSecondaryLargeTextStyle,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
              itemCount: provider.selectedImages.length + 1,
              itemBuilder: (context, index) {
                if (index == provider.selectedImages.length) {
                  if (provider.selectedImages.length < provider.imageLimit) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: openCamera,
                        child: Container(
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.add,
                            color: AppColors.primaryColor,
                            size: 48,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        if (provider.selectedImages.isNotEmpty) {
                          provider.removeImage(index);
                        }
                      },
                      child: Stack(
                        children: [
                          Image.file(
                            File(provider.selectedImages[index]),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          if (provider.selectedImages.isNotEmpty)
                            const Positioned(
                              top: 0,
                              right: 0,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        // if (selectedImages.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: ElevatedButton(
            onPressed: () {
              provider.postData();
            },
            child: const Text("Aceptar"),
          ),
        )
      ],
    );
  }
}
