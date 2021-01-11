import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'widget/overview_balance.dart';
import 'widget/overview_range_form.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  static const routeName = '/home';
  static const overviewRangeIconKey = Key('home_overview_range_icon');
  static const appBarTitle = 'Geldstroom';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            key: HomePage.overviewRangeIconKey,
            icon: Icon(Icons.filter_list_sharp),
            onPressed: () => showOverviewRangeFilter(context),
          )
        ],
      ),
      body: ListView(
        children: [
          OverviewBalance(),
        ],
      ),
    );
  }

  void showOverviewRangeFilter(BuildContext context) {
    showMaterialModalBottomSheet(
      builder: (_) => OverviewRangeForm(),
      context: context,
    );
  }
}
