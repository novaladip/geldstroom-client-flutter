import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc_ui/ui_bloc.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/widget/widget.dart';

class OverviewRangeForm extends StatelessWidget {
  static const dropdownFormKey = Key('overview_range_form_dropdown');
  static const title = 'Select Overview Range';
  static const option = [
    OverviewRangeState.weekly(),
    OverviewRangeState.monthly(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OverviewRangeCubit>().state;

    return <Widget>[
      Text(title)
          .fontFamily(AppStyles.fontFamilyTitle)
          .fontSize(32.sp)
          .fontWeight(FontWeight.bold),
      SizedBox(height: 13.h),
      DropdownForm<OverviewRangeState>(
        key: OverviewRangeForm.dropdownFormKey,
        labelText: 'Range',
        currentValue: state,
        options: OverviewRangeForm.option,
        onChanged: (value) => onChange(context, value),
        renderItem: (value) =>
            Text(value.currentValue).fontFamily(AppStyles.fontFamilyBody),
      ),
    ]
        .toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .height(0.2.sh)
        .padding(horizontal: AppStyles.defaultPaddingHorizontal, vertical: 20.h)
        .backgroundColor(AppStyles.darkBackground);
  }

  void onChange(BuildContext context, OverviewRangeState value) {
    context.read<OverviewRangeCubit>().onChangeRange(value);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
