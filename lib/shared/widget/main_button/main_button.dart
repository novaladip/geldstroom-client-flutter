import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/config/config.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key key,
    @required this.title,
    @required this.onTap,
    this.loading = false,
    this.disabled = false,
  }) : super(key: key);

  static const titleKey = Key('main_button_title');
  static const loadingIndicatorKey = Key('main_button_loading');

  final String title;
  final bool loading;
  final bool disabled;
  final VoidCallback onTap;

  Widget styledTitle() => Text(title, key: MainButton.titleKey)
      .fontFamily(AppStyles.fontFamilyTitle)
      .fontWeight(FontWeight.bold)
      .fontSize(28.sp)
      .textColor(AppStyles.textWhite)
      .center();

  Widget loadingIndicator() => SpinKitRotatingCircle(
        key: MainButton.loadingIndicatorKey,
        color: AppStyles.textWhite,
        size: 28.sp,
      );

  Widget get child => loading ? loadingIndicator() : styledTitle();

  @override
  Widget build(BuildContext context) {
    return Styled.widget(child: child)
        .animate(Duration(seconds: 1), Curves.easeIn)
        .decorated(
          color: AppStyles.mainButtonColor,
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
        )
        .height(60.h)
        .width(double.infinity)
        .gestures(
          onTap: disabled || loading ? null : onTap,
        );
  }
}
