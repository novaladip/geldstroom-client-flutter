import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../gen/assets.gen.dart';
import '../../common/config/config.dart';
import '../widget.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key key,
    @required this.message,
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

class ErrorMessageRetry extends StatelessWidget {
  static const retryText = 'Retry';

  const ErrorMessageRetry({
    Key key,
    this.message,
    @required this.onRetry,
  }) : super(key: key);

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Assets.images.fetchError.svg(height: .3.sh).padding(bottom: 20.h),
      Text(message)
          .fontSize(32.sp)
          .fontWeight(FontWeight.w500)
          .fontFamily(AppStyles.fontFamilyTitle)
          .textAlignment(TextAlign.center),
      SizedBox(height: 20.h),
      MainButton(
        title: retryText,
        onTap: onRetry,
      ),
    ].toColumn().padding(top: 0.13.sh);
  }
}
