import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/bloc.dart';
import '../../shared/widget/widget.dart';
import '../ui.dart';
import 'widgets/request_category_list.dart';

class RequestCategoryPage extends StatefulWidget {
  static const routeName = '/request-category';
  static const appBarTitle = 'Request Category';
  static const emptyText = 'There is no requested category yet';

  const RequestCategoryPage({Key key}) : super(key: key);

  @override
  _RequestCategoryPageState createState() => _RequestCategoryPageState();
}

class _RequestCategoryPageState extends State<RequestCategoryPage> {
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(RequestCategoryPage.appBarTitle),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => Navigator.of(context)
              .pushNamed(RequestCategoryCreatePage.routeName),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Builder(
        builder: (context) {
          final state = context.watch<RequestCategoryCubit>().state;
          return state.status.maybeWhen(
            loadInProgress: () => LoadingIndicator(),
            initial: () => LoadingIndicator(),
            loadFailure: (e) => ErrorMessageRetry(
              message: 'Failed to fetch data',
              onRetry: fetch,
            ),
            orElse: () => RefreshIndicator(
              onRefresh: fetch,
              child: RequestCategoryList(
                isEmpty: state.isEmpty,
                items: state.data,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    fetch();
    super.initState();
  }

  Future<void> fetch() async {
    context.read<RequestCategoryCubit>().fetch();
  }
}
