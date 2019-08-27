import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geldstroom/provider/overviews.dart';
import 'package:geldstroom/utils/format_currency.dart';
import 'package:geldstroom/widgets/shared/balance_chart.dart';
import 'package:geldstroom/widgets/shared/loading_animated_switcher.dart';
import 'package:provider/provider.dart';

class OverviewBalance extends StatefulWidget {
  @override
  _OverviewBalanceState createState() => _OverviewBalanceState();
}

class _OverviewBalanceState extends State<OverviewBalance> {
  var _initializing = true;
  var _isLoading = true;

  @override
  didChangeDependencies() {
    if (_initializing) {
      _fetchBalance();
    }
    _setInitializing(false);
    super.didChangeDependencies();
  }

  Future<void> _fetchBalance() async {
    try {
      _setLoading(true);
      await Provider.of<Overviews>(context).fetchBalance();
      _setLoading(false);
    } catch (error) {
      _setLoading(false);
    }
  }

  _setInitializing(bool value) {
    setState(() {
      _initializing = value;
    });
  }

  _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Overviews>(
      builder: (ctx, overviews, _) {
        return Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              _buildBalanceChart(overviews),
              _buildContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildTotalOverview(
                        title: 'Income', value: overviews.balance.income),
                    SizedBox(
                      width: 1,
                      child: Container(
                        height: 30,
                        color: Colors.white54,
                      ),
                    ),
                    _buildTotalOverview(
                        title: 'Expense', value: overviews.balance.expense)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContainer({@required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 30),
      width: double.infinity,
      child: child,
    );
  }

  Widget _buildTotalOverview({@required String title, @required int value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: Colors.white54),
        ),
        Text(
          formatCurrency(value),
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildBalanceChart(Overviews overviews) => LoadingAnimatedSwitcher(
        isLoading: _isLoading,
        onLoadingChild: _loadingIndicator(),
        onFinishChild: BalanceChart(
          balanceSegment: [
            BalanceSegment(
              segment: 'Income',
              size: overviews.balance.income,
              color: Theme.of(context).primaryColor,
            ),
            BalanceSegment(
              segment: 'Expense',
              size: overviews.balance.expense,
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      );

  Widget _loadingIndicator() => Container(
        height: 200,
        child: SpinKitFoldingCube(
          color: Colors.white,
          size: 100,
        ),
      );
}
