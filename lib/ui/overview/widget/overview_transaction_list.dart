import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/model/model.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/widget/widget.dart';
import '../../transaction_edit/transaction_edit_page.dart';
import 'overview_transaction_empty.dart';
import 'overview_transaction_loading_footer.dart';

class OverviewTransactionList extends StatelessWidget {
  const OverviewTransactionList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactions =
        context.select<OverviewTransactionBloc, List<Transaction>>(
      (bloc) => bloc.state.data,
    );

    final isEmpty = context
        .select<OverviewTransactionBloc, bool>((bloc) => bloc.state.isEmpty);

    final onDeleteProgressIds =
        context.select<TransactionDeleteCubit, List<String>>(
      (cubit) => cubit.state.onDeleteProgressIds,
    );

    if (isEmpty) {
      return SliverList(
        delegate: SliverChildListDelegate([
          OverviewTransactionEmpty(),
        ]),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final data = transactions[index];

          return <Widget>[
            TransactionCard(
              data: data,
              isDeleting: onDeleteProgressIds.contains(data.id),
              onDelete: () =>
                  context.read<TransactionDeleteCubit>().delete(data.id),
              onEdit: () => onEdit(context, data),
            ),
            if (transactions.length - 1 == index)
              OverviewTransactionLoadingFooter()
          ].toColumn().backgroundColor(AppStyles.darkBackground);
        },
        childCount: transactions.length,
      ),
    );
  }

  void onEdit(BuildContext context, Transaction data) {
    showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      expand: false,
      builder: (context) => TransactionEditPage(data: data),
    );
  }
}
