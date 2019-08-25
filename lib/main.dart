import 'package:flutter/material.dart';
import 'package:geldstroom/config/app.config.dart';
import 'package:geldstroom/provider/auth.dart';
import 'package:geldstroom/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'package:geldstroom/provider/all_provider.dart';
import 'package:geldstroom/screens/login_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: allProvider,
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: AppConfig.title,
          theme: AppConfig.theme,
          routes: AppConfig.routes,
          home: auth.isAuthenticated ? HomeScreen() : LoginScreen(),
        ),
      ),
    );
  }
}
