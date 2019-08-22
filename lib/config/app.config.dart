import 'package:flutter/material.dart';

import 'package:geldstroom/screens/home_screen.dart';
import 'package:geldstroom/screens/login_screen.dart';
import 'package:geldstroom/screens/register_screen.dart';

class AppConfig {
  static final title = 'Geldstroom';
  static final theme = ThemeData(
      primarySwatch: Colors.deepPurple,
      accentColor: Colors.pinkAccent,
      appBarTheme: AppBarTheme());
  static final routes = {
    LoginScreen.routeName: (BuildContext context) => LoginScreen(),
    RegisterScreen.routeName: (BuildContext context) => RegisterScreen(),
    HomeScreen.routeName: (BuildContext context) => HomeScreen(),
  };
}
