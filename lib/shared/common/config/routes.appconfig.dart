import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/bloc_ui/ui_bloc.dart';
import '../../../ui/ui.dart';
import '../utils/utils.dart';

Map<String, WidgetBuilder> buildRoutes() {
  final routes = <String, Widget Function(BuildContext)>{
    SplashScreenPage.routeName: (_) => BlocProvider.value(
          value: getIt<AuthCubit>(),
          child: SplashScreenPage(),
        ),
    IntroPage.routeName: (_) => IntroPage(),
    HomePage.routeName: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<OverviewRangeCubit>()),
            BlocProvider.value(value: getIt<OverviewBalanceCubit>()),
            BlocProvider.value(value: getIt<OverviewTransactionBloc>()),
          ],
          child: HomePage(),
        ),
    LoginPage.routeName: (_) => BlocProvider.value(
          value: getIt<LoginCubit>(),
          child: LoginPage(),
        ),
    RegisterPage.routeName: (_) => BlocProvider.value(
          value: getIt<RegisterCubit>(),
          child: RegisterPage(),
        ),
    RegisterSuccessPage.routeName: (_) => RegisterSuccessPage(),
    ResetPasswordPage.routeName: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: getIt<ResetPasswordCubit>(),
            ),
            BlocProvider.value(
              value: getIt<RequestOtpCubit>(),
            ),
          ],
          child: ResetPasswordPage(),
        ),
  };

  return routes;
}
