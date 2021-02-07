import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../ui.dart';

class RegisterFooter extends StatelessWidget {
  static const text = 'Already have an account? Sign in';

  RegisterFooter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(RegisterFooter.text)
        .fontSize(28.sp)
        .textAlignment(TextAlign.center)
        .gestures(
          onTap: () => Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginPage.routeName, (_) => false),
        )
        .padding(bottom: 25.h);
  }
}
