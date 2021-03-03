import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../core/bloc/bloc.dart';
import '../../core/bloc_base/bloc_base.dart';
import '../../shared/common/config/config.dart';
import '../../shared/common/utils/utils.dart';
import '../ui.dart';
import 'widget/overview_appbar.dart';
import 'widget/overview_balance.dart';
import 'widget/overview_title.dart';
import 'widget/overview_transaction.dart';

class OverviewPage extends StatefulWidget {
  OverviewPage({Key key}) : super(key: key);

  static const routeName = '/overview';
  static const customScrollViewKey = Key('home_page_scrollview');

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  ScrollController scrollController;
  bool showFAB = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: !showFAB
          ? null
          : FloatingActionButton(
              mini: true,
              backgroundColor: AppStyles.mainButtonColor,
              child: Icon(Icons.add),
              onPressed: () => showTransactionCreatePage(context),
            ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TransactionDeleteCubit, DeleteState>(
            listener: deleteSuccessListener,
            listenWhen: (prevState, state) =>
                state.shouldListenDeleteSuccess(prevState),
          ),
          BlocListener<TransactionDeleteCubit, DeleteState>(
            listener: deleteFailureListener,
            listenWhen: (prevState, state) =>
                state.shoudListenDeleteFailure(prevState),
          )
        ],
        child: RefreshIndicator(
          color: AppStyles.darkBackground,
          onRefresh: onRefresh,
          child: CustomScrollView(
            key: OverviewPage.customScrollViewKey,
            controller: scrollController,
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: <Widget>[
              OverviewAppBar(),
              OverviewTitle(),
              OverviewBalance(),
              OverviewTransaction(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    context
        .read<OverviewTransactionBloc>()
        .add(OverviewTransactionEvent.fetch());
    context.read<OverviewBalanceCubit>().fetch();
  }

  void showTransactionCreatePage(BuildContext context) {
    showMaterialModalBottomSheet(
      builder: (_) => TransactionCreatePage(),
      useRootNavigator: true,
      context: context,
    );
  }

  void scrollListener() {
    final triggerFetchMoreSizze =
        0.9 * scrollController.position.maxScrollExtent;

    if (scrollController.position.pixels > triggerFetchMoreSizze) {
      context
          .read<OverviewTransactionBloc>()
          .add(OverviewTransactionEvent.fetchMore());
    }
  }

  void scrollListenerFAB() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (showFAB == true) {
        setState(() {
          showFAB = false;
        });
      }
    }

    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (showFAB == false) {
        setState(() {
          showFAB = true;
        });
      }
    }
  }

  void deleteSuccessListener(
    BuildContext context,
    DeleteState state,
  ) {
    CustomSnackbar.createSuccess(
      message: 'Transaction has been deleted',
    )..show(context);
  }

  void deleteFailureListener(
    BuildContext context,
    DeleteState state,
  ) {
    CustomSnackbar.createError(
      message: 'Failed to delete transaction',
    )..show(context);
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    scrollController.addListener(scrollListenerFAB);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.removeListener(scrollListenerFAB);
    scrollController.dispose();
    super.dispose();
  }
}
