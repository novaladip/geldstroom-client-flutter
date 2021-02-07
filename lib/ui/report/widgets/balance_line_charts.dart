import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/model/model.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/widget/widget.dart';

class BalanceLineCharts extends StatefulWidget {
  @override
  _BalanceLineChartsState createState() => _BalanceLineChartsState();
}

class _BalanceLineChartsState extends State<BalanceLineCharts>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Styled.widget(
      child: Builder(
        builder: (context) {
          final status = context.select<BalanceReportCubit, FetchStatus>(
            (cubit) => cubit.state.status,
          );

          return status.maybeWhen(
            loadFailure: (e) => ErrorMessageRetry(
              message: e.message,
              onRetry: fetch,
            ),
            initial: () => LoadingIndicator(),
            loadInProgress: () => LoadingIndicator(),
            orElse: () => BalanceLineChart(),
          );
        },
      ).padding(horizontal: AppStyles.defaultPaddingHorizontal, vertical: 25.h),
    );
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  void fetch() {
    context.read<BalanceReportCubit>().fetch();
  }

  @override
  bool get wantKeepAlive => true;
}

class BalanceLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context
        .select<BalanceReportCubit, BalanceReport>((cubit) => cubit.state.data);

    if (data.isEmpty) {
      return Center(
        child: Text('There is not enough data'),
      );
    }

    return Container(
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: 0),
          labelStyle: TextStyle(color: Colors.white),
          desiredIntervals: 2,
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          numberFormat: NumberFormat.compactCurrency(
            symbol: 'IDR',
          ),
          labelStyle: TextStyle(color: Colors.white),
          axisLine: AxisLine(width: 0, color: Colors.white),
          majorTickLines: MajorTickLines(color: Colors.transparent),
        ),
        series: <ChartSeries>[
          LineSeries<BalanceReportData, String>(
            name: 'Income',
            dataSource: data.income,
            xValueMapper: (income, _) => Jiffy(income.date).format('MM/dd/yy'),
            yValueMapper: (income, _) => income.total,
            color: Colors.green,
            markerSettings: MarkerSettings(isVisible: true),
          ),
          LineSeries<BalanceReportData, String>(
            name: 'Expense',
            dataSource: data.expense,
            xValueMapper: (income, _) => Jiffy(income.date).format('MM/dd/yy'),
            yValueMapper: (income, _) => income.total,
            color: Colors.red,
            markerSettings: MarkerSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}
