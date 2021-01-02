import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/bloc.dart';
import '../../../ui/ui.dart';
import '../utils/utils.dart';

Map<String, Widget Function(BuildContext)> buildRoutes() {
  final routes = <String, Widget Function(BuildContext)>{
    SplashScreenPage.routeName: (_) => BlocProvider.value(
          value: getIt<AuthCubit>(),
          child: SplashScreenPage(),
        ),
    IntroPage.routeName: (_) => IntroPage(),
    HomePage.routeName: (_) => HomePage(),
    LoginPage.routeName: (_) => BlocProvider.value(
          value: getIt<LoginCubit>(),
          child: LoginPage(),
        ),
    RegisterPage.routeName: (_) => BlocProvider.value(
          value: getIt<RegisterCubit>(),
          child: RegisterPage(),
        )
  };

  return routes;
}
