import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/bloc/bloc.dart';
import 'widget/overview_balance.dart';
import 'widget/overview_range_form.dart';
import 'widget/overview_transaction.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  static const routeName = '/home';
  static const customScrollViewKey = Key('home_page_scrollview');
  static const overviewRangeIconKey = Key('home_overview_range_icon');
  static const appBarTitle = 'Geldstroom';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(HomePage.appBarTitle),
        actions: [
          IconButton(
            key: HomePage.overviewRangeIconKey,
            icon: Icon(Icons.filter_list_sharp),
            onPressed: () => showOverviewRangeFilter(context),
          )
        ],
      ),
      body: CustomScrollView(
        key: HomePage.customScrollViewKey,
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: OverviewBalance().padding(bottom: 30.h),
          ),
          OverviewTransaction(),
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

  void scrollListener() {
    final triggerFetchMoreSizze =
        0.9 * scrollController.position.maxScrollExtent;

    if (scrollController.position.pixels > triggerFetchMoreSizze) {
      context
          .read<OverviewTransactionBloc>()
          .add(OverviewTransactionEvent.fetchMore());
    }
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
