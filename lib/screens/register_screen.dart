import 'package:flutter/material.dart';
import 'package:geldstroom/widgets/button_gradient.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';
  const RegisterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register Screen'),
      ),
      body: Center(
        child: Hero(
          tag: 'button',
          child: ButtonGradient(
            child: Text(
              'REGISTER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            gradient: LinearGradient(
              colors: [
                primaryColor,
                accentColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
