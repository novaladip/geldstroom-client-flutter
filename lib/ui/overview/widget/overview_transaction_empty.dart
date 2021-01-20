import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/common/config/config.dart';

class OverviewTransactionEmpty extends StatelessWidget {
  const OverviewTransactionEmpty({Key key}) : super(key: key);

  static const emptyText = 'There is no transaction yet';

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      SizedBox(height: 0.1.sh),
      Assets.images.empty.svg(height: 0.25.sh),
      SizedBox(height: 20.h),
      Text(emptyText)
          .fontSize(30.sp)
          .fontFamily(AppStyles.fontFamilyBody)
          .fontWeight(FontWeight.bold)
    ].toColumn();
  }
}
