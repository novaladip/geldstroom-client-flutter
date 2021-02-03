import 'package:flutter/material.dart';

import 'widgets/request_category_create_form.dart';

class RequestCategoryCreatePage extends StatelessWidget {
  static const routeName = '/request-category/create';
  static const title = 'Create Request Category';

  const RequestCategoryCreatePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RequestCategoryCreatePage.title),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: RequestCategoryCreateForm(),
      ),
    );
  }
}
