import 'package:flutter/material.dart';
import 'package:geldstroom/provider/overviews.dart';
import 'package:geldstroom/widgets/shared/snackbar_notification.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:geldstroom/screens/add_transaction_screen.dart';
import 'package:geldstroom/widgets/overview_balance.dart';
import 'package:geldstroom/widgets/overview_transactions.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  HomeScreen({Key key}) : super(key: key);

  Future<void> _refresh(BuildContext context) async {
    try {
      final future = [
        Provider.of<Overviews>(context, listen: false).fetchBalance(),
        Provider.of<Overviews>(context, listen: false).fetchTransactions(),
      ];
      await Future.wait(future);
      _refreshController.refreshCompleted();
    } catch (error) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        snackBarNotification(
          text: 'Failed to refresh, please try again.',
          type: SnackBarNotificationType.ERROR,
        ),
      );
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today Overviews'),
        backgroundColor: Colors.black,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () => _refresh(context),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              OverviewBalance(),
              OverviewTransactions(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Opacity(opacity: 0.8, child: Icon(Icons.add)),
        onPressed: () =>
            Navigator.of(context).pushNamed(AddTransactionScreen.routeName),
        mini: true,
      ),
    );
  }
}
