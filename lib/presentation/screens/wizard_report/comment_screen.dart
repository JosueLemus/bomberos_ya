import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bomberos_ya/config/theme/text_styles.dart';
import 'package:bomberos_ya/presentation/providers/simple_report_provider.dart';
import 'package:bomberos_ya/presentation/widgets/microphone_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import '../../widgets/custom_record_button.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  const CommentsScreen({super.key});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecorindg = false;
  String audioPath = '';
  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    if (isRecorindg) {
      return;
    }
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecorindg = true;
        });
      }
    } catch (e) {
      debugPrint("Error Start recording: $e");
    }
  }

  Future<void> stopRecording() async {
    if (!isRecorindg) {
      return;
    }
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecorindg = false;
        audioPath = path ?? '';
      });
    } catch (e) {
      debugPrint("Error Stopping record: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      debugPrint('Error playing Recording: $e');
    }
  }

  // Añade este método para enviar el audio
  Future<void> sendAudio() async {
    if (audioPath.isNotEmpty) {
      try {
        final base64Audio = await AudioConversionUtil.convertAudioToBase64(File(audioPath));
        ref.read(simpleReportProvider).audioBase64 = base64Audio;
        // Envía base64Audio al backend o realiza otras operaciones según tus necesidades
        debugPrint('Audio en formato base64: $base64Audio');
      } catch (e) {
        debugPrint('Error al enviar el audio: $e');
      }
    } else {
      // Maneja el caso en el que no hay audio grabado
      debugPrint('No hay audio grabado para enviar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: const [
              Text(
                "Agrega un comentario de la situación.",
                style: TextStyles.boldSecondaryLargeTextStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Graba un mensaje de voz para explicar tu situación actual y cualquier detalle relevante.",
                style: TextStyles.regularSecondaryMediumTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          MicrophoneButton(startRecording: startRecording),
          if (isRecorindg)
            CustomRecordButton(icon: Icons.stop, onTap: stopRecording),
          if (!isRecorindg && audioPath.isNotEmpty)
            CustomRecordButton(
                icon: Icons.play_arrow_rounded, onTap: playRecording),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                // Añade un botón para enviar el audio
                ElevatedButton(
                  onPressed: sendAudio,
                  child: const Text('Enviar audio',
                      style: TextStyles.filledButtonTextStyle),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Enviar texto",
                      style: TextStyles.textButtonTextStyle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// import 'dart:convert';
// import 'dart:io';

class AudioConversionUtil {
  static Future<String> convertAudioToBase64(File audioFile) async {
    if (audioFile != null && audioFile.existsSync()) {
      List<int> audioBytes = await audioFile.readAsBytes();
      String base64Audio = base64Encode(audioBytes);
      return base64Audio;
    } else {
      throw Exception('El archivo de audio no existe o es nulo.');
    }
  }
}

class ImageConversionUtil {
  static Future<List<String>> convertImagesToBase64(List<XFile> imageFiles) async {
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
