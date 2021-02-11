import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../core/bloc/bloc.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: () => onRefresh(context),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: BalanceLineCharts(
                constraints: constraints,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> onRefresh(BuildContext context) async {
    await context.read<BalanceReportCubit>().refresh();
  }
}
