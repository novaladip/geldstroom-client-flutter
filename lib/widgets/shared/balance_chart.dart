import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:geldstroom/utils/format_currency.dart';

class BalanceChart extends StatefulWidget {
  final List<BalanceSegment> balanceSegment;

  const BalanceChart({
    Key key,
    @required this.balanceSegment,
  }) : super(key: key);

  @override
  _BalanceChartState createState() => _BalanceChartState();
}

class _BalanceChartState extends State<BalanceChart> {
  List<charts.Series<BalanceSegment, String>> _seriesList;

  void _generateData() {
    setState(() {
      setState(() {
        _seriesList.add(
          charts.Series(
            domainFn: (BalanceSegment balanceSegment, _) =>
                balanceSegment.segment,
            measureFn: (BalanceSegment balanceSegment, _) =>
                balanceSegment.size,
            id: 'balance',
            data: widget.balanceSegment,
            colorFn: (BalanceSegment balanceSegment, _) =>
                charts.ColorUtil.fromDartColor(balanceSegment.color),
          ),
        );
      });
    });
  }

  @override
  void initState() {
    _seriesList = List<charts.Series<BalanceSegment, String>>();
    _generateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 200,
            child: charts.PieChart(
              _seriesList,
              animate: true,
              animationDuration: Duration(milliseconds: 1500),
              behaviors: [
                charts.DatumLegend(
                    position: charts.BehaviorPosition.top,
                    outsideJustification:
                        charts.OutsideJustification.startDrawArea,
                    entryTextStyle:
                        charts.TextStyleSpec(color: charts.Color.white))
              ],
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                children: <Widget>[
                  Text(
                    'Balance',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    formatCurrency(
                      (widget.balanceSegment[0].size -
                          widget.balanceSegment[1].size),
                    ),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BalanceSegment {
  final String segment;
  final int size;
  final Color color;

  BalanceSegment({
    @required this.segment,
    @required this.size,
    @required this.color,
  });
}
