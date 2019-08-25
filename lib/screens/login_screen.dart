import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:geldstroom/config/app.config.dart';
import 'package:geldstroom/provider/auth.dart';
import 'package:geldstroom/screens/home_screen.dart';
import 'package:geldstroom/screens/register_screen.dart';
import 'package:geldstroom/utils/validate_input.dart';
import 'package:geldstroom/widgets/button_gradient.dart';
import 'package:geldstroom/widgets/quotes.dart';
import 'package:geldstroom/widgets/text_input.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var isLoading = false;

  void _onSubmit() async {
    try {
      setIsLoading(true);
      final isValid = _form.currentState.validate();
      if (isValid) {
        await Provider.of<Auth>(context)
            .login(_emailController.text, _passwordController.text);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
      setIsLoading(false);
    } catch (error) {
      setIsLoading(false);
    }
  }

  setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;
    final horizontalPadding = EdgeInsets.symmetric(horizontal: 8.0);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Quotes(quote: AppConfig.quotes),
              SizedBox(height: 50),
              Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    TextInput(
                      labelText: 'Email Address',
                      textEditingController: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                      onFieldSubmitted: () => _passwordFocusNode.requestFocus(),
                    ),
                    TextInput(
                      labelText: 'Password',
                      obscureText: true,
                      textEditingController: _passwordController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocusNode,
                      validator: validatePassword,
                      onFieldSubmitted: _onSubmit,
                    ),
                  ],
                ),
              ),
              FlatButton(
                child: Text('Don\'t have an account? Sign up.'),
                onPressed: () =>
                    Navigator.of(context).pushNamed(RegisterScreen.routeName),
              ),
              Container(
                padding: horizontalPadding,
                margin: EdgeInsets.only(bottom: 15),
                child: ButtonGradient(
                  child: buttonChild(),
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      accentColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onPressed: isLoading ? null : _onSubmit,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonChild() {
    if (isLoading) {
      return SpinKitDualRing(color: Colors.white, size: 32);
    } else {
      return Text(
        'LOGIN',
        style: TextStyle(color: Colors.white, fontSize: 18),
      );
    }
  }
}
