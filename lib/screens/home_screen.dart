import 'package:flutter/material.dart';
import 'package:geldstroom/provider/overviews.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overviews = Provider.of<Overviews>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Screen'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('expense: ' + overviews.balance.expense.toString()),
            Text('income: ' + overviews.balance.income.toString()),
            if (overviews.isTransactionEmpty) Text('No transaction today'),
            RaisedButton(
              child: Text('Fetch Balance'),
              onPressed: () => overviews.fetchBalance(),
            ),
            RaisedButton(
              child: Text('Fetch Transaction'),
              onPressed: () => overviews.fetchTransactions(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: overviews.transaction.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        alignment: Alignment.center,
                        child: Text(overviews.transaction[index].id)),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
