import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import 'widget/register_footer.dart';
import 'widget/register_form.dart';
import 'widget/register_header.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = '/register';
  static const appBarTitleText = 'Create Account';

  RegisterPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitleText),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: IntrinsicHeight(
              child: <Widget>[
                RegisterHeader(),
                RegisterForm().expanded(),
                RegisterFooter(),
              ].toColumn(),
            ).constrained(minHeight: constraints.maxHeight),
          );
        },
      ),
    );
  }
}
