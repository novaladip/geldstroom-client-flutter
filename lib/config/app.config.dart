import 'package:flutter/material.dart';
import 'package:geldstroom/screens/add_transaction_screen.dart';

import 'package:geldstroom/screens/home_screen.dart';
import 'package:geldstroom/screens/login_screen.dart';
import 'package:geldstroom/screens/register_screen.dart';

class AppConfig {
  static final title = 'Geldstroom';
  static final theme = ThemeData(
    primarySwatch: Colors.deepPurple,
    accentColor: Colors.pinkAccent,
    appBarTheme: AppBarTheme(),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
  static final routes = {
    LoginScreen.routeName: (BuildContext context) => LoginScreen(),
    RegisterScreen.routeName: (BuildContext context) => RegisterScreen(),
    HomeScreen.routeName: (BuildContext context) => HomeScreen(),
    AddTransactionScreen.routeName: (BuildContext context) =>
        AddTransactionScreen(),
  };
  static final quotes =
      "You can never understand everything. But, you should push yourself to understand the system. - Ryan Dahl";
}
