import 'package:bomberos_ya/presentation/widgets/message_alerts.dart';
import 'package:flutter/material.dart';

class AppAlerts {
  static void showAlertMssg(
      {required String title,
      required String description,
      required BuildContext context,
      Function? onClose}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return MessageAlert(
          title: title,
          message: description,
          onClose: onClose,
        );
      },
    ).then((value) => () {
          if (onClose != null) {
            onClose();
          }
        });
  }
}
