import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/model/model.dart';
import '../../../shared/common/config/theme.dart';
import '../../../shared/widget/widget.dart';
import 'overview_transaction_loading_footer.dart';

class OverviewTransactionList extends StatelessWidget {
  const OverviewTransactionList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactions =
        context.select<OverviewTransactionBloc, List<Transaction>>(
      (bloc) => bloc.state.data,
    );

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return <Widget>[
            TransactionCard(
              data: transactions[index],
              onDelete: () {},
              onEdit: () {},
            ),
            if (transactions.length - 1 == index)
              OverviewTransactionLoadingFooter()
          ].toColumn().backgroundColor(AppStyles.darkBackground);
        },
        childCount: transactions.length,
      ),
    );
  }
}
