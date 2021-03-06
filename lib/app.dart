import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_routes.dart';
import 'core/bloc/bloc.dart';
import 'core/bloc_ui/ui_bloc.dart';
import 'shared/common/config/config.dart';
import 'shared/common/utils/utils.dart';
import 'ui/ui.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenUtil.init(
          constraints,
          designSize: Size(750, 1334),
          allowFontScaling: false,
        );

        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<AuthCubit>()..appStarted()),
            BlocProvider.value(value: getIt<OverviewRangeCubit>()),
            BlocProvider.value(value: getIt<ReportFilterCubit>()),
            BlocProvider.value(value: getIt<CategoryCubit>()..fetch()),
            BlocProvider.value(value: getIt<TransactionCreateCubit>()),
            BlocProvider.value(value: getIt<TransactionEditCubit>()),
            BlocProvider.value(value: getIt<TransactionDeleteCubit>()),
            BlocProvider.value(value: getIt<BalanceReportCubit>()),
            BlocProvider.value(value: getIt<ResendEmailVerificationCubit>()),
          ],
          child: MaterialApp(
            title: 'Geldstroom',
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                elevation: 0,
                centerTitle: true,
                color: AppStyles.darkBackground,
                brightness: Brightness.dark,
                iconTheme: IconThemeData(color: AppStyles.textWhite),
                textTheme: TextTheme(
                  headline6: TextStyle(
                    color: AppStyles.textWhite,
                    fontSize: 20,
                    fontFamily: AppStyles.fontFamilyTitle,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              primaryColor: AppStyles.primaryColor,
              scaffoldBackgroundColor: AppStyles.darkBackground,
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: AppStyles.textWhite,
                    displayColor: AppStyles.textWhite,
                    fontFamily: AppStyles.fontFamilyBody,
                  ),
            ),
            routes: buildRoutes(),
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            home: SplashScreenPage(),
          ),
        );
      },
    );
  }
}
