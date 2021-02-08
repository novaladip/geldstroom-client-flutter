import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../config/config.dart';

class CustomSnackbar {
  final String message;
  final SnackBarBehavior snackBarBehavior;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;

  const CustomSnackbar({
    @required this.message,
    this.snackBarBehavior = SnackBarBehavior.floating,
    this.backgroundColor = AppStyles.mainButtonColor,
    this.textColor = Colors.white,
    this.duration = const Duration(seconds: 2),
  });

  Widget get snackbar => SnackBar(
        behavior: snackBarBehavior,
        backgroundColor: backgroundColor,
        duration: duration,
        content: Text(message, overflow: TextOverflow.ellipsis, maxLines: 3)
            .fontSize(28.sp)
            .fontFamily(AppStyles.fontFamilyBody)
            .textColor(textColor),
      );

  factory CustomSnackbar.createError({
    @required String message,
    SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating,
    Duration duration = const Duration(seconds: 2),
  }) {
    return CustomSnackbar(
      message: message,
      backgroundColor: Color(0XFFFF5056),
      textColor: Colors.white,
      snackBarBehavior: snackBarBehavior,
      duration: duration,
    );
  }

  factory CustomSnackbar.createSuccess({
    @required String message,
    SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating,
    Duration duration = const Duration(seconds: 2),
  }) {
    return CustomSnackbar(
      message: message,
      backgroundColor: Color(0XFF1FBB9E),
      textColor: Colors.white,
      snackBarBehavior: snackBarBehavior,
      duration: duration,
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context,
  ) {
    Scaffold.of(context).hideCurrentSnackBar();
    return Scaffold.of(context).showSnackBar(snackbar);
  }
}
