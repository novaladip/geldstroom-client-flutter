import 'package:flutter/material.dart';

import '../page/home/home_page.dart';
import '../page/intro/intro_page.dart';
import '../page/splash_screen/splash_screen_page.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  SplashScreenPage.routeName: (_) => SplashScreenPage(),
  IntroPage.routeName: (_) => IntroPage(),
  HomePage.routeName: (_) => HomePage(),
};
