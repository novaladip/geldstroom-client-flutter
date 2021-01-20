import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/bloc_ui/ui_bloc.dart';
import '../../../core/network/network.dart';
import '../../../shared/common/config/config.dart';
import 'overview_balance_item.dart';

class OverviewBalance extends StatefulWidget {
  OverviewBalance({Key key}) : super(key: key);

  static const title = 'Your transaction overview\nthis';

  @override
  _OverviewBalanceState createState() => _OverviewBalanceState();
}

class _OverviewBalanceState extends State<OverviewBalance> {
  @override
  Widget build(BuildContext context) {
    final transactionTotal =
        context.select<OverviewBalanceCubit, TransactionTotal>(
      (cubit) => cubit.state.data,
    );
    final overviewRange = context.select<OverviewRangeCubit, String>(
      (cubit) => cubit.state.when(
        monthly: () => 'month',
        weekly: () => 'week',
      ),
    );

    return <Widget>[
      Text('${OverviewBalance.title} $overviewRange')
          .fontSize(40.sp)
          .fontFamily(AppStyles.fontFamilyBody)
          .fontWeight(FontWeight.bold)
          .padding(right: 200.w),
      SizedBox(height: 32.h),
      <Widget>[
        OverviewBalanceItem(
          position: OverviewBalanceItemPosition.left,
          title: 'Income',
          amount: transactionTotal.income,
        ),
        SizedBox(width: 13.w),
        OverviewBalanceItem(
          position: OverviewBalanceItemPosition.right,
          title: 'Expense',
          amount: transactionTotal.expense,
        ),
      ].toRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).padding(
          horizontal: AppStyles.defaultPaddingHorizontal,
          top: 20.h,
        );
  }

  @override
  void initState() {
    fetchInitialData();
    super.initState();
  }

  void fetchInitialData() {
    final cubit = context.read<OverviewBalanceCubit>();
    cubit.state.status.maybeWhen(
      initial: cubit.fetch,
      orElse: () {},
    );
  }
}
