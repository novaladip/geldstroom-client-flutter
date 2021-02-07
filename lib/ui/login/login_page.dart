import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import 'widget/login_footer.dart';
import 'widget/login_form.dart';
import 'widget/login_header.dart';

final loginPageKey = UniqueKey();

class LoginPage extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: loginPageKey,
      bottomNavigationBar: LoginFooter(),
      body: SingleChildScrollView(
        child: <Widget>[
          LoginHeader(),
          LoginForm(),
        ].toColumn(),
      ),
    );
  }
}
