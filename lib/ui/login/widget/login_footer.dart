import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/common/config/config.dart';

class LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return <Widget>[
      _StyledText(
        'New to Geldstroom? ',
        color: AppStyles.textGray,
      ),
      _StyledText(
        'Sign up',
        color: AppStyles.textWhite,
        fontWeight: FontWeight.bold,
      ),
    ]
        .toRow(
      mainAxisAlignment: MainAxisAlignment.center,
    )
        .gestures(
      onTap: () {
        // @TODO
        // Push to Register Page
      },
    );
  }
}

class _StyledText extends StatelessWidget {
  _StyledText(
    this.text, {
    this.color = Colors.white,
    this.fontWeight = FontWeight.normal,
  });

  final String text;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text)
        .textColor(color)
        .fontSize(28.sp)
        .fontFamily(AppStyles.fontFamilyTitle)
        .fontWeight(fontWeight);
  }
}
