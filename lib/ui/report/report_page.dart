import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../shared/common/config/config.dart';
import 'widgets/balance_report_page.dart';
import 'widgets/report_filter_form.dart';
import 'widgets/transaction_report_page.dart';

class ReportPage extends StatefulWidget {
  static const routeName = '/report';
  static const title = 'Report';

  const ReportPage({
    Key key,
  }) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

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
        bottom: TabBar(
          controller: tabController,
          indicatorColor: AppStyles.primaryColor,
          labelColor: AppStyles.primaryColor,
          unselectedLabelColor: AppStyles.textGray,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: 'Balance Chart'),
            Tab(text: 'Transaction Report'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          BalanceReportPage(),
          TransactionReportPage(),
        ],
      ),
    );
  }
}
