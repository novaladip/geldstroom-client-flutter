import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntroPage extends StatelessWidget {
  static const routeName = '/intro';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(),
    );
  }
}
