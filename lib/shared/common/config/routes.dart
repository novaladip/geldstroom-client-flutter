import 'package:flutter/material.dart';
import '../../../ui/ui.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  SplashScreenPage.routeName: (_) => SplashScreenPage(),
  IntroPage.routeName: (_) => IntroPage(),
  HomePage.routeName: (_) => HomePage(),
};
