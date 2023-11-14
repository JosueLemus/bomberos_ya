import 'package:flutter/material.dart';

class MessageAlert extends StatelessWidget {
  final String title;
  final String message;
  final Function? onClose;

  const MessageAlert(
      {super.key, required this.title, required this.message, this.onClose});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onClose != null) {
              onClose!();
            }
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
