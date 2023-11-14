import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Base64Converter {
  static Future<String> convertAudioToBase64(File audioFile) async {
    if (audioFile.existsSync()) {
      List<int> audioBytes = await audioFile.readAsBytes();
      String base64Audio = base64Encode(audioBytes);
      return base64Audio;
    } else {
      throw Exception('El archivo de audio no existe o es nulo.');
    }
  }

  static Future<List<String>> convertImagesToBase64(
      List<XFile> imageFiles) async {
    final List<String> base64Images = [];

    for (final imageFile in imageFiles) {
      if (imageFile != null && File(imageFile.path).existsSync()) {
        final List<int> imageBytes = await File(imageFile.path).readAsBytes();
        final String base64Image = base64Encode(imageBytes);
        base64Images.add(base64Image);
      } else {
        throw Exception('Uno o más archivos de imagen no existen o son nulos.');
      }
    }

    return base64Images;
  }
}
