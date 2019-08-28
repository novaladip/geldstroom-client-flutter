import 'package:flutter/material.dart';
import 'package:geldstroom/screens/add_transaction_screen.dart';

import 'package:geldstroom/widgets/overview_balance.dart';
import 'package:geldstroom/widgets/overview_transactions.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today Overviews'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            OverviewBalance(),
            OverviewTransactions(),
          ],
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
