import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../shared/common/config/config.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon).iconColor(Colors.white).iconSize(50.sp),
        SizedBox(width: 10.w),
        <Widget>[
          Text(title).fontSize(28.sp).fontFamily(AppStyles.fontFamilyBody),
        ].toColumn(),
      ],
    )
        .padding(vertical: 20.h, horizontal: AppStyles.defaultPaddingHorizontal)
        .ripple(
          splashColor: AppStyles.mainButtonColor,
          highlightColor: AppStyles.appBarColor,
        )
        .gestures(onTap: onTap);
  }
}
