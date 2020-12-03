import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/auth/auth_cubit.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'page/splash_screen/splash_screen_page.dart';
import 'util/injector/injector.dart';

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

        return BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>()..appStarted(),
          child: MaterialApp(
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
          ),
        );
      },
    );
  }
}
