import 'package:flutter/material.dart';

enum SnackBarNotificationType { ERROR, SUCCESS }

SnackBar snackBarNotification({
  SnackBarNotificationType type,
  String text,
  Duration duration: const Duration(seconds: 1),
}) {
  return SnackBar(
    duration: duration,
    content: Row(
      children: <Widget>[
        Icon(type == SnackBarNotificationType.ERROR
            ? Icons.error_outline
            : Icons.verified_user),
        SizedBox(width: 10),
        Text(text),
      ],
    ),
    backgroundColor:
        type == SnackBarNotificationType.ERROR ? Colors.red : Colors.green,
  );
}
