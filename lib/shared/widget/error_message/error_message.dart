import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geldstroom/gen/assets.gen.dart';
import 'package:geldstroom/shared/common/config/config.dart';
import 'package:styled_widget/styled_widget.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key key,
    this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Assets.images.fetchError.svg(height: .3.sh).padding(bottom: 20.h),
      Text(message)
          .fontSize(32.sp)
          .fontWeight(FontWeight.w500)
          .fontFamily(AppStyles.fontFamilyTitle)
          .textAlignment(TextAlign.center),
    ].toColumn().padding(top: 0.13.sh);
  }
}
