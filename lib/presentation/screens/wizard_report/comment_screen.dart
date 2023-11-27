import 'package:audioplayers/audioplayers.dart';
import 'package:bomberos_ya/config/theme/text_styles.dart';
import 'package:bomberos_ya/presentation/providers/simple_report_provider.dart';
import 'package:bomberos_ya/presentation/widgets/app_button.dart';
import 'package:bomberos_ya/presentation/widgets/microphone_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final provider = ref.read(simpleReportProvider);
      String? path = await audioRecord.stop();
      if (path != null) {
        provider.saveRecord(path);
      }
      setState(() {
        isRecorindg = false;
      });
    } catch (e) {
      debugPrint("Error Stopping record: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      final provider = ref.read(simpleReportProvider);
      Source urlSource = UrlSource(provider.audioPath ?? "");
      await audioPlayer.play(urlSource);
    } catch (e) {
      debugPrint('Error playing Recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(simpleReportProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            children: [
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
          if (!isRecorindg && (provider.audioPath?.isNotEmpty ?? false))
            CustomRecordButton(
                icon: Icons.play_arrow_rounded, onTap: playRecording),
          AppButton(
            onPressed: (provider.audioPath == null || isRecorindg)
                ? null
                : provider.goToNextPage,
            text: "Enviar audio",
            padding: const EdgeInsets.only(bottom: 32),
          )
          // Image.asset("assets/frequency_image.gif")
        ],
      ),
    );
  }
}
