import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../intro/intro_page.dart';

class SplashScreenPage extends StatefulWidget {
  static const routeName = '/splash_screen';

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Center(
          child: FlatButton(
            child: Text('S'),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(IntroPage.routeName);
            },
          ),
        ),
      ),
    );
  }
}
