import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constant/assets.gen.dart';

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
        body: Assets.images.splash.image(
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
