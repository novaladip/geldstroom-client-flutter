import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../shared/common/config/config.dart';

class ConfirmationDialog {
  const ConfirmationDialog({
    @required this.title,
    @required this.content,
    @required this.onConfirm,
  });

  final String title;
  final String content;
  final VoidCallback onConfirm;

  Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppStyles.darkBackground,
          title: Text(title)
              .fontSize(32.sp)
              .fontFamily(AppStyles.fontFamilyTitle)
              .fontWeight(FontWeight.w500)
              .textColor(AppStyles.primaryColor),
          content: Text(content).fontSize(30.sp).fontWeight(FontWeight.normal),
          actions: [
            FlatButton(
              textColor: Colors.redAccent,
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('Confirm'),
              onPressed: () => newMethod(context),
            ),
          ],
        );
      },
    );
  }

  void newMethod(BuildContext context) {
    onConfirm();
    Navigator.of(context).pop();
  }
}
