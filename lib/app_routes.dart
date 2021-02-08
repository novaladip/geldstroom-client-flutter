import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/bloc/bloc.dart';
import 'core/bloc_ui/ui_bloc.dart';
import 'shared/common/utils/utils.dart';
import 'ui/ui.dart';

Map<String, WidgetBuilder> buildRoutes() {
  final routes = <String, Widget Function(BuildContext)>{
    SplashScreenPage.routeName: (_) => BlocProvider.value(
          value: getIt<AuthCubit>(),
          child: SplashScreenPage(),
        ),
    IntroPage.routeName: (_) => IntroPage(),
    OverviewPage.routeName: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<OverviewRangeCubit>()),
            BlocProvider.value(value: getIt<OverviewBalanceCubit>()),
            BlocProvider.value(value: getIt<OverviewTransactionBloc>()),
          ],
          child: OverviewPage(),
        ),
    HomePage.routeName: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<BottomNavigationCubit>()),
            BlocProvider.value(value: getIt<OverviewRangeCubit>()),
            BlocProvider.value(value: getIt<OverviewBalanceCubit>()),
            BlocProvider.value(value: getIt<OverviewTransactionBloc>()),
            BlocProvider.value(value: getIt<ProfileCubit>()),
          ],
          child: HomePage(
            oneSignal: getIt<OneSignal>(),
            children: [
              OverviewPage(),
              ReportPage(),
              SettingPage(),
            ],
          ),
        ),
    SettingPage.routeName: (_) => SettingPage(),
    LoginPage.routeName: (_) => BlocProvider.value(
          value: getIt<LoginCubit>(),
          child: LoginPage(),
        ),
    RegisterPage.routeName: (_) => BlocProvider.value(
          value: getIt<RegisterCubit>(),
          child: RegisterPage(),
        ),
    PasswordChangePage.routeName: (_) => BlocProvider.value(
          value: getIt<PasswordChangeCubit>(),
          child: PasswordChangePage(),
        ),
    RegisterSuccessPage.routeName: (_) => RegisterSuccessPage(),
    PasswordResetPage.routeName: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: getIt<PasswordResetCubit>(),
            ),
            BlocProvider.value(
              value: getIt<RequestOtpCubit>(),
            ),
          ],
          child: PasswordResetPage(),
        ),
    RequestCategoryPage.routeName: (_) => BlocProvider.value(
          value: getIt<RequestCategoryCubit>(),
          child: RequestCategoryPage(),
        ),
    RequestCategoryCreatePage.routeName: (_) => BlocProvider.value(
          value: getIt<RequestCategoryCreateCubit>(),
          child: RequestCategoryCreatePage(),
        ),
    CreditPage.routeName: (_) => CreditPage(),
  };

  return routes;
}
