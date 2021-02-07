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
      bottomNavigationBar: RegisterFooter(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: <Widget>[
              RegisterHeader(),
              RegisterForm(),
            ].toColumn(),
          );
        },
      ),
    );
  }
}
