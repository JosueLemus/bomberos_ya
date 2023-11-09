import 'dart:io';

import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/theme/text_styles.dart';

class AddImagesScreen extends StatefulWidget {
  const AddImagesScreen({super.key});

  @override
  _AddImagesScreenState createState() => _AddImagesScreenState();
}

class _AddImagesScreenState extends State<AddImagesScreen> {
  List<XFile> selectedImages = [];
  int imageLimit = 4;

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        if (selectedImages.length < imageLimit) {
          selectedImages.add(image);
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Agrega imágenes de la situación (${selectedImages.length} de $imageLimit)",
          style: TextStyles.boldSecondaryLargeTextStyle,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
              itemCount: selectedImages.length + 1,
              itemBuilder: (context, index) {
                if (index == selectedImages.length) {
                  if (selectedImages.length < imageLimit) {
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
                        onTap: _openCamera,
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
                        if (selectedImages.isNotEmpty) {
                          _removeImage(index);
                        }
                      },
                      child: Stack(
                        children: [
                          Image.file(
                            File(selectedImages[index].path),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          if (selectedImages.isNotEmpty)
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
        if (selectedImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: ElevatedButton(
              onPressed: () {
                // Agregar lógica para procesar las imágenes
              },
              child: const Text("Aceptar"),
            ),
          )
        else
          Container(),
      ],
    );
  }
}
