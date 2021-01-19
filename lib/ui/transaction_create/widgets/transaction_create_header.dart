import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../shared/common/config/config.dart';

class TransactionCreateHeader extends StatelessWidget {
  const TransactionCreateHeader({Key key}) : super(key: key);

  static const title = 'Add Transaction';

  @override
  Widget build(BuildContext context) {
    return Text(title)
        .fontSize(34.sp)
        .fontWeight(FontWeight.w500)
        .textAlignment(TextAlign.center)
        .fontFamily(AppStyles.fontFamilyTitle)
        .padding(top: 30.h, vertical: 50.h);
  }
}
