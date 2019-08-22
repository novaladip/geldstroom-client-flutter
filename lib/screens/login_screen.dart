import 'package:flutter/material.dart';
import 'package:geldstroom/widgets/quotes.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Quotes(
              quote:
                  "Do not worry if you have built your castles in the air. They are where they should be. Now put the foundations under them.",
            ),
          ],
        ),
      ),
    );
  }
}
