import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../config/config.dart';

class CustomSnackbar {
  final String title;
  final String message;
  final IconData iconData;
  final SnackBarBehavior snackBarBehavior;
  final Color backgroundColor;
  final Color textColor;
  final Duration duration;

  const CustomSnackbar({
    @required this.message,
    this.title,
    this.iconData,
    this.snackBarBehavior = SnackBarBehavior.floating,
    this.backgroundColor = AppStyles.mainButtonColor,
    this.textColor = Colors.white,
    this.duration = const Duration(seconds: 2),
  });

  Widget get snackbar => SnackBar(
        behavior: snackBarBehavior,
        backgroundColor: backgroundColor,
        duration: duration,
        content: <Widget>[
          if (iconData != null)
            ...<Widget>[
              Icon(iconData).iconColor(textColor).iconSize(40.sp),
              SizedBox(width: 5.w),
            ].toList(),
          <Widget>[
            if (title != null)
              ...<Widget>[
                Text(title)
                    .fontSize(27.sp)
                    .fontFamily(AppStyles.fontFamilyTitle)
                    .fontWeight(FontWeight.w500)
                    .textColor(textColor),
                SizedBox(height: 1.h),
              ].toList(),
            Text(message)
                .fontSize(25.sp)
                .fontFamily(AppStyles.fontFamilyBody)
                .textColor(textColor)
          ].toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
          )
        ]
            .toRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
            )
            .fittedBox(),
      );

  factory CustomSnackbar.createError({
    @required String message,
    String title,
    SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating,
    Duration duration = const Duration(seconds: 2),
  }) {
    return CustomSnackbar(
      title: title,
      message: message,
      backgroundColor: Color(0XFFFF5056),
      textColor: Colors.white,
      snackBarBehavior: snackBarBehavior,
      duration: duration,
      iconData: Icons.warning,
    );
  }

  factory CustomSnackbar.createSuccess({
    @required String message,
    String title,
    SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating,
    Duration duration = const Duration(seconds: 2),
  }) {
    return CustomSnackbar(
      title: title,
      message: message,
      backgroundColor: Color(0XFF1FBB9E),
      textColor: Colors.white,
      snackBarBehavior: snackBarBehavior,
      duration: duration,
      iconData: Icons.check_circle,
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context,
  ) {
    Scaffold.of(context).hideCurrentSnackBar();
    return Scaffold.of(context).showSnackBar(snackbar);
  }
}
