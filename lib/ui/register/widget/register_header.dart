import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/common/config/config.dart';

class RegisterHeader extends StatelessWidget {
  static const quotes =
      '“Beware of little expense; a small leak will sink a great ship.” '
      '\n\n~Benjamin Franklin~';

  RegisterHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(RegisterHeader.quotes)
          .fontSize(32.sp)
          .letterSpacing(3.sp)
          .fontFamily(AppStyles.fontFamilyTitle)
          .fontWeight(FontWeight.w600)
          .textAlignment(TextAlign.center),
    ].toColumn().padding(
          horizontal: AppStyles.defaultPaddingHorizontal,
          top: 20.h,
          bottom: 50.h,
        );
  }
}
