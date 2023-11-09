import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

class MicrophoneButton extends StatelessWidget {

  final Function() startRecording;
  const MicrophoneButton({super.key, required this.startRecording});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: startRecording,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(175)),
        child: Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(175)),
            child: Center(
              child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(175)),
                  child: const Icon(
                    Icons.mic,
                    size: 150,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
