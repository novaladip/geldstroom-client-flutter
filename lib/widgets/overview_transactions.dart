import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geldstroom/provider/overviews.dart';
import 'package:geldstroom/widgets/shared/loading_animated_switcher.dart';
import 'package:geldstroom/widgets/shared/transaction_item.dart';
import 'package:provider/provider.dart';

class OverviewTransactions extends StatefulWidget {
  @override
  _OverviewTransactionsState createState() => _OverviewTransactionsState();
}

class _OverviewTransactionsState extends State<OverviewTransactions> {
  var _initializing = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_initializing) {
      fetchTransactions();
    }

    setState(() {
      _initializing = false;
    });

    super.didChangeDependencies();
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void fetchTransactions() async {
    try {
      _setLoading(true);
      await Provider.of<Overviews>(context).fetchTransactions();
      _setLoading(false);
    } catch (error) {
      _setLoading(false);
      throw error;
    }
  }

  final containerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(30),
      topLeft: Radius.circular(30),
    ),
  );

  Widget _loadingIndicator() => SpinKitChasingDots(
        color: Theme.of(context).accentColor,
        size: 100,
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).accentColor,
        child: Container(
          width: double.infinity,
          decoration: containerDecoration,
          padding: EdgeInsets.only(top: 20, left: 8, right: 8),
          child: LoadingAnimatedSwitcher(
            isLoading: _isLoading,
            onLoadingChild: _loadingIndicator(),
            onFinishChild: Consumer<Overviews>(
              builder: (ctx, overview, _) => ListView.builder(
                itemCount: overview.transaction.length,
                itemBuilder: (ctx, index) => TransactionItem(
                  transaction: overview.transaction[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
