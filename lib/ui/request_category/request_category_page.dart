import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/bloc.dart';
import '../../shared/widget/widget.dart';
import '../ui.dart';
import 'widgets/request_category_item.dart';

class RequestCategoryPage extends StatefulWidget {
  static const routeName = '/request-category';
  static const appBarTitle = 'Request Category';
  static const emptyText = 'There is no requested category yet';

  const RequestCategoryPage({Key key}) : super(key: key);

  @override
  _RequestCategoryPageState createState() => _RequestCategoryPageState();
}

class _RequestCategoryPageState extends State<RequestCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RequestCategoryPage.appBarTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context)
                .pushNamed(RequestCategoryCreatePage.routeName),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final state = context.watch<RequestCategoryCubit>().state;
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: state.status.maybeWhen(
              loadFailure: (e) => ErrorMessageRetry(
                message: 'Failed to fetch data',
                onRetry: fetch,
              ),
              loadInProgress: () => LoadingIndicator(),
              initial: () => LoadingIndicator(),
              orElse: () {
                if (state.isEmpty) {
                  return Center(
                    child: Text(RequestCategoryPage.emptyText),
                  );
                }

                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: state.data.length,
                  itemBuilder: (context, index) => RequestCategoryItem(
                    data: state.data[index],
                    isLast: index == state.data.length - 1,
                    onDelete: () {},
                    onEdit: () {},
                  ),
                );
              },
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

  void fetch() {
    context.read<RequestCategoryCubit>().fetch();
  }
}
