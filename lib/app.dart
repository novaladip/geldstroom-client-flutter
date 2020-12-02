import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'page/splash_screen/splash_screen_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenUtil.init(
          constraints,
          designSize: Size(750, 1334),
          allowFontScaling: true,
        );

        return MaterialApp(
          title: 'Geldstroom',
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: AppStyles.primaryColor,
            scaffoldBackgroundColor: AppStyles.darkBackground,
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: AppStyles.textWhite,
                  displayColor: AppStyles.textWhite,
                  fontFamily: AppStyles.fontFamilyBody,
                ),
          ),
          routes: routes,
          home: SplashScreenPage(),
        );
      },
    );
  }
}
