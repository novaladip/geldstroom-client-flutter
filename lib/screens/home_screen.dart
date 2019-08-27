import 'package:flutter/material.dart';
import 'package:geldstroom/models/transaction.dart';
import 'package:geldstroom/provider/records.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final records = Provider.of<Records>(context);
    print(records.transaction);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Screen'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(records.balance.expense.toString()),
            RaisedButton(
              child: Text('Fetch Transaction'),
              onPressed: () => records.getBalance('2018/08/26',
                  isMonthly: IsMonthly.MONTHLY),
            ),
            RaisedButton(
              child: Text('Fetch More Transaction'),
              onPressed: () =>
                  records.loadMore('2019/08/26', isMonthly: IsMonthly.MONTHLY),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: records.transaction.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        alignment: Alignment.center,
                        child: Text(records.transaction[index].id)),
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
