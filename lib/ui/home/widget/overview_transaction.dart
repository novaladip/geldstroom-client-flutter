import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/model/model.dart';
import '../../../shared/widget/widget.dart';

class OverviewTransaction extends StatefulWidget {
  const OverviewTransaction({Key key}) : super(key: key);

  static const loadingKey = Key('overview_transaction_loading');
  static const errorText = 'Ops something went wrong \n pull to refresh';

  @override
  _OverviewTransactionState createState() => _OverviewTransactionState();
}

class _OverviewTransactionState extends State<OverviewTransaction> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<OverviewTransactionBloc>().state;

    return state.status.maybeWhen<Widget>(
      loadFailure: (_) => ErrorMessage(message: OverviewTransaction.errorText)
          .parent(({child}) => SliverToBoxAdapter(child: child)),
      loadInProgress: () => SpinKitCubeGrid(
        key: OverviewTransaction.loadingKey,
        color: Colors.white,
        size: 150.sp,
      )
          .padding(top: .15.sh)
          .center()
          .parent(({child}) => SliverToBoxAdapter(child: child)),
      orElse: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (state.data.length - 1 != index) {
              return TransactionCard(
                data: state.data[index],
                onDelete: () {},
                onEdit: () {},
              );
            }

            return <Widget>[
              TransactionCard(
                data: state.data[index],
                onDelete: () {},
                onEdit: () {},
              ),
              if (state.status == FetchStatus.fetchMoreInProgress())
                SpinKitCircle(
                  size: 80.sp,
                  color: Colors.white,
                ).center(),
              SizedBox(height: 100.h),
            ].toColumn();
          },
          childCount: state.data.length,
        ),
      ),
    );
  }

  @override
  void initState() {
    fetchInitialData();
    super.initState();
  }

  void fetchInitialData() {
    context
        .read<OverviewTransactionBloc>()
        .add(OverviewTransactionEvent.fetch());
  }
}
