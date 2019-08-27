import 'package:flutter/material.dart';

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
    );
  }
}
