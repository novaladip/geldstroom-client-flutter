import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'widgets/balance_line_charts.dart';
import 'widgets/report_filter_form.dart';

class ReportPage extends StatelessWidget {
  static const routeName = '/report';
  static const title = 'Report';

  const ReportPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ReportPage.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_outlined),
            onPressed: () {
              showMaterialModalBottomSheet(
                context: context,
                useRootNavigator: true,
                builder: (context) => ReportFilterForm(),
              );
            },
          ),
        ],
      ),
      body: BalanceLineCharts(),
    );
  }
}
