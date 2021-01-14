import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../shared/common/config/theme.dart';
import '../../../shared/common/utils/utils.dart';

enum OverviewBalanceItemPosition {
  left,
  right,
}

class OverviewBalanceItem extends StatelessWidget {
  final int amount;
  final String title;
  final OverviewBalanceItemPosition position;

  const OverviewBalanceItem({
    Key key,
    @required this.amount,
    @required this.title,
    @required this.position,
  }) : super(key: key);

  CrossAxisAlignment get crossAxisLignment {
    if (position == OverviewBalanceItemPosition.left) {
      return CrossAxisAlignment.start;
    }
    return CrossAxisAlignment.end;
  }

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(title)
          .fontSize(32.sp)
          .textColor(Colors.white)
          .fontWeight(FontWeight.w500)
          .fontFamily(AppStyles.fontFamilyBody),
      Text(FormatCurrency.toIDR(amount))
          .fontSize(30.sp)
          .textColor(AppStyles.primaryColor)
          .fontWeight(FontWeight.w600)
          .fontFamily(AppStyles.fontFamilyBody)
          .fittedBox(),
    ].toColumn(crossAxisAlignment: crossAxisLignment).flexible();
  }
}
