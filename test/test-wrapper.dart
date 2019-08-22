import 'package:flutter/material.dart';

class TestWrapper extends StatelessWidget {
  final Widget child;

  const TestWrapper({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
}
