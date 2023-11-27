import 'dart:convert';
import 'dart:io';

class Base64Converter {
  static Future<String> convertAudioToBase64(File audioFile) async {
    try {
      if (audioFile.existsSync()) {
        List<int> audioBytes = await audioFile.readAsBytes();
        String base64Audio = base64Encode(audioBytes);
        return base64Audio;
      } else {
        throw Exception('El archivo de audio no existe o es nulo.');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<String>> convertImagesToBase64(
      List<String> imagePaths) async {
    try {
      final List<String> base64Images = [];

      for (final imagePath in imagePaths) {
        if (File(imagePath).existsSync()) {
          final List<int> imageBytes = await File(imagePath).readAsBytes();
          final String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          throw Exception(
              'Uno o más archivos de imagen no existen o son nulos.');
        }
      }

      return base64Images;
    } catch (e) {
      rethrow;
    }
  }
}
