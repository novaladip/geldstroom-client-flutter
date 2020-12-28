import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../shared/common/config/config.dart';

const loginHeaderTitle = 'Geldstroom';
const loginHeaderSubtitle = 'Sign in to your account';

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(loginHeaderTitle)
          .fontSize(60.sp)
          .fontWeight(FontWeight.bold)
          .fontFamily(AppStyles.fontFamilyTitle),
      Text(loginHeaderSubtitle)
          .fontSize(32.sp)
          .fontFamily(AppStyles.fontFamilyBody),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.center,
        )
        .padding(top: 0.08.sh);
  }
}
