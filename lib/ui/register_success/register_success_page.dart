import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../gen/assets.gen.dart';
import '../../shared/common/config/config.dart';
import '../../shared/widget/widget.dart';
import '../ui.dart';

class RegisterSuccessPage extends StatelessWidget {
  static const routeName = '/register/success';
  static const title = 'Verify your email';
  static const subtitle = 'An email verification has been send to your email, '
      'please check your email for further instruction.';
  static const continueButtonText = 'Continue to login';

  RegisterSuccessPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        SvgPicture.asset(
          Assets.images.inbox.path,
          height: 0.3.sh,
        ),
        SizedBox(height: 30.h),
        Text(RegisterSuccessPage.title)
            .fontSize(32.sp)
            .fontWeight(FontWeight.bold)
            .fontFamily(AppStyles.fontFamilyTitle),
        SizedBox(height: 13.h),
        Text(RegisterSuccessPage.subtitle)
            .fontSize(30.sp)
            .fontWeight(FontWeight.w500)
            .fontFamily(AppStyles.fontFamilyBody)
            .textAlignment(TextAlign.center),
        SizedBox(height: 30.h),
        MainButton(
          title: RegisterSuccessPage.continueButtonText,
          onTap: () => Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginPage.routeName, (_) => false),
        ),
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
          )
          .padding(horizontal: AppStyles.defaultPaddingHorizontal),
    );
  }
}
