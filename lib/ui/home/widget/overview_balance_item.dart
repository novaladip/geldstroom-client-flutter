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

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(title)
          .fontSize(32.sp)
          .fontFamily(AppStyles.fontFamilyBody)
          .fontWeight(FontWeight.w500)
          .textColor(Colors.white),
      Text(FormatCurrency.toIDR(amount))
          .textColor(AppStyles.primaryColor)
          .fontSize(30.sp)
          .fontFamily(AppStyles.fontFamilyBody)
          .fontWeight(FontWeight.w600)
          .fittedBox(),
    ]
        .toColumn(
          crossAxisAlignment: position == OverviewBalanceItemPosition.left
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
        )
        .flexible();
  }
}
