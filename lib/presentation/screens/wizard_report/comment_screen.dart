import 'package:audioplayers/audioplayers.dart';
import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/config/theme/text_styles.dart';
import 'package:bomberos_ya/presentation/widgets/microphone_button.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

import '../../widgets/custom_record_button.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
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
                "Agrega un comentario de la situacion.",
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
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Aceptar',
                            style: TextStyles.filledButtonTextStyle))),
                TextButton(
                  onPressed: () {},
                  child: const Text("Enviar texto",
                      style: TextStyles.textButtonTextStyle),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
