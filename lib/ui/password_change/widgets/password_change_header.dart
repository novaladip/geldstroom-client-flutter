import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../shared/common/config/config.dart';

class PasswordChangeHeader extends StatelessWidget {
  const PasswordChangeHeader({Key key}) : super(key: key);

  static const title = 'Change Password';
  static const subtitle = 'If you forgot your current password '
      'you can sign out then go to Reset Password Page';

  static const backIconKey = Key('password_change_header_back_icon');

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      if (canPop(context))
        ...[
          Icon(Icons.arrow_back, key: backIconKey)
              .iconColor(Colors.white)
              .iconSize(64.sp)
              .ripple()
              .gestures(onTap: () => Navigator.of(context).pop()),
          SizedBox(height: 20.h),
        ].toList(),
      <Widget>[
        Text(title)
            .fontSize(32.sp)
            .fontFamily(AppStyles.fontFamilyTitle)
            .fontWeight(FontWeight.w500),
        SizedBox(height: 6.h),
        Text(subtitle, maxLines: 3).fontSize(28.sp),
      ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(
          horizontal: AppStyles.defaultPaddingHorizontal,
          vertical: 25.h,
        );
  }

  bool canPop(BuildContext context) => Navigator.of(context).canPop();
}
