import 'package:flutter/material.dart';

final homePageKey = UniqueKey();

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homePageKey,
    );
  }
}
