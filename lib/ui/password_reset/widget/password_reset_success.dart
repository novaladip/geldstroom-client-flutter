import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/widget/widget.dart';
import '../../ui.dart';

class PasswordResetSuccess extends StatelessWidget {
  PasswordResetSuccess({Key key}) : super(key: key);

  static const title = 'Your password has been updated';
  static const subtitle = 'Now you can login within your new password.';
  static const continueButtonText = 'Continue to Sign In';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        <Widget>[
          SvgPicture.asset(
            Assets.images.success.path,
            height: 0.3.sh,
          ),
          SizedBox(height: 32.h),
          Text(title)
              .fontSize(32.sp)
              .fontWeight(FontWeight.bold)
              .textAlignment(TextAlign.center)
              .fontFamily(AppStyles.fontFamilyTitle),
          Text(subtitle)
              .fontSize(32.sp)
              .fontWeight(FontWeight.bold)
              .textAlignment(TextAlign.center)
              .fontFamily(AppStyles.fontFamilyBody),
        ]
            .toColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            )
            .expanded(),
        MainButton(
          title: continueButtonText,
          onTap: () => onContinue(context),
        ),
        SizedBox(height: 60.h),
      ].toColumn().padding(horizontal: AppStyles.defaultPaddingHorizontal),
    );
  }

  void onContinue(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginPage.routeName,
      (_) => false,
    );
  }
}
