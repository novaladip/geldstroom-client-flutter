import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../shared/common/config/config.dart';
import '../../ui.dart';

const loginFooterText = 'New to Geldstroom? ';
const loginFooterText2 = 'Sign up';

class LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return <Widget>[
      _StyledText(
        loginFooterText,
        color: AppStyles.textGray,
      ),
      _StyledText(
        loginFooterText2,
        color: AppStyles.textWhite,
        fontWeight: FontWeight.bold,
      ),
    ]
        .toRow(
          mainAxisAlignment: MainAxisAlignment.center,
        )
        .gestures(
          onTap: () => Navigator.of(context).pushNamed(RegisterPage.routeName),
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
