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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  var _credentialsError = '';

  void _onSubmit() async {
    try {
      if (_emailController.text.isEmpty && _passwordController.text.isEmpty) {
        return null;
      }
      _setIsLoading(true);
      final isValid = _form.currentState.validate();
      if (isValid) {
        await Provider.of<Auth>(context)
            .login(_emailController.text, _passwordController.text);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
      _setIsLoading(false);
    } catch (error) {
      _setIsLoading(false);
      _showSnackbar('$error');
      _credentialsError = '$error';
    }
  }

  void _showSnackbar(String text) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: Row(
        children: <Widget>[
          Icon(Icons.error_outline),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
      backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _setIsLoading(bool value) {
    setState(() {
      _credentialsError = '';
      _isLoading = value;
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
      key: _scaffoldKey,
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
                      icon: Icon(Icons.mail_outline),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                      onFieldSubmitted: () => _passwordFocusNode.requestFocus(),
                    ),
                    TextInput(
                      labelText: 'Password',
                      textEditingController: _passwordController,
                      icon: Icon(Icons.lock_outline),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocusNode,
                      validator: validatePassword,
                      errorText: _credentialsError.isNotEmpty
                          ? _credentialsError
                          : null,
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
                  onPressed: _isLoading ? null : _onSubmit,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonChild() {
    if (_isLoading) {
      return SpinKitDualRing(color: Colors.white, size: 32);
    } else {
      return Text(
        'SIGN IN',
        style: TextStyle(color: Colors.white, fontSize: 18),
      );
    }
  }
}
