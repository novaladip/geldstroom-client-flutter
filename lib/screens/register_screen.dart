import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geldstroom/provider/auth.dart';
import 'package:geldstroom/utils/validate_input.dart';
import 'package:geldstroom/widgets/button_gradient.dart';
import 'package:geldstroom/widgets/quotes.dart';
import 'package:geldstroom/widgets/text_input.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _scaffold = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordComfirmationController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _passwordComfirmationFocusNode = FocusNode();
  var _isLoading = false;
  String _errorEmail;

  Widget _buttonChild() {
    return _isLoading
        ? SpinKitDualRing(color: Colors.white, size: 32)
        : Text(
            'SIGN UP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          );
  }

  void _showSnackbar(String text, String type) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 5),
      content: Row(
        children: <Widget>[
          Icon(type == 'error' ? Icons.error_outline : Icons.verified_user),
          SizedBox(width: 10),
          Text(text),
        ],
      ),
      backgroundColor: type == 'error' ? Colors.red : Colors.green,
    );
    _scaffold.currentState.removeCurrentSnackBar();
    _scaffold.currentState.showSnackBar(snackBar);
  }

  Future<void> _onSubmit() async {
    try {
      if (_emailController.text.isEmpty &&
          _passwordController.text.isEmpty &&
          _passwordComfirmationController.text.isEmpty &&
          _isLoading) {
        return;
      }
      _resetError();
      _setLoading(true);
      final isValid = _form.currentState.validate();
      if (!isValid) {
        _setLoading(false);
        return;
      }
      await Provider.of<Auth>(context)
          .register(_emailController.text, _passwordController.text);
      _showSnackbar('Successfully register, now you can sign in.', 'success');
      _clearFormValue();
      _setLoading(false);
    } catch (error) {
      if (error.toString() == 'Email is already exist') {
        _setEmailError(error.toString());
      }
      _showSnackbar('$error', 'error');
      _setLoading(false);
    }
  }

  void _resetError() {
    _setEmailError(null);
  }

  void _setEmailError(String value) {
    setState(() {
      _errorEmail = value;
    });
  }

  void _clearFormValue() {
    _emailController.text = '';
    _passwordController.text = '';
    _passwordComfirmationController.text = '';
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quote =
        'It is not enough to do your best: you must know what to do, and then do your best. - W. Edwards Deming';
    final primaryColor = Theme.of(context).primaryColor;
    final accentColor = Theme.of(context).accentColor;
    final horizontalPadding = EdgeInsets.symmetric(horizontal: 8);
    return Scaffold(
      key: _scaffold,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    Quotes(quote: quote),
                    SizedBox(height: 50),
                    TextInput(
                      labelText: 'Email Address',
                      textEditingController: _emailController,
                      errorText: _errorEmail,
                      icon: Icon(Icons.mail_outline),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: validateEmail,
                      onFieldSubmitted: _passwordFocusNode.requestFocus,
                    ),
                    TextInput(
                      labelText: 'Password',
                      focusNode: _passwordFocusNode,
                      textEditingController: _passwordController,
                      obscureText: true,
                      icon: Icon(Icons.lock_outline),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: validatePassword,
                      onFieldSubmitted:
                          _passwordComfirmationFocusNode.requestFocus,
                    ),
                    TextInput(
                      labelText: 'Password Comfirmation',
                      focusNode: _passwordComfirmationFocusNode,
                      textEditingController: _passwordComfirmationController,
                      obscureText: true,
                      icon: Icon(Icons.lock_outline),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (value) => validatePasswordComfirmation(
                          value, _passwordController.text),
                      onFieldSubmitted: _onSubmit,
                    ),
                  ],
                ),
              ),
              FlatButton(
                child: Text('Already have an account? Sign in.'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Container(
                padding: horizontalPadding,
                margin: EdgeInsets.only(bottom: 15),
                child: ButtonGradient(
                  child: _buttonChild(),
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      accentColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onPressed: () {
                    _onSubmit();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
