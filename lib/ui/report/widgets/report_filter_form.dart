import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/bloc_ui/ui_bloc.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/widget/widget.dart';

class ReportFilterForm extends StatelessWidget {
  static const startDateInputKey = Key('report_filter_form_start_date');
  static const endDateInputKey = Key('report_filter_form_end_date');

  ReportFilterForm({Key key}) : super(key: key);

  final firstDate = Jiffy().startOf(Units.YEAR).subtract(Duration(days: 366));
  final lastDate = Jiffy().endOf(Units.MONTH);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportFilterCubit>().state;

    return Styled.widget(
      child: <Widget>[
        const Text('Select Date Range'),
        SizedBox(height: 20.h),
        DateFormField(
          key: startDateInputKey,
          labelText: 'Start Date',
          currentValue: state.start,
          firstDate: firstDate,
          lastDate: lastDate,
          onChange: (value) =>
              context.read<ReportFilterCubit>().changeStart(value),
        ),
        DateFormField(
          key: endDateInputKey,
          labelText: 'End Date',
          currentValue: state.end,
          onChange: (value) =>
              context.read<ReportFilterCubit>().changeEnd(value),
          firstDate: state.start.add(Duration(days: 1)),
          lastDate: lastDate,
        ),
        SizedBox(height: 20.h),
        MainButton(
          title: 'Apply',
          onTap: () => onSubmit(context),
        ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    )
        .height(0.33.sh)
        .padding(horizontal: AppStyles.defaultPaddingHorizontal, vertical: 20.h)
        .backgroundColor(AppStyles.darkBackground);
  }

  void onSubmit(BuildContext context) {
    context.read<BalanceReportCubit>().fetch();
    Navigator.of(context).pop();
  }
}
