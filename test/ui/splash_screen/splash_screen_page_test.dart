import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/ui/ui.dart';

import '../../test_helper.dart';

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  group('SplashScreenPage()', () {
    AuthCubit authCubit;
    Widget subject;
    final homePageKey = UniqueKey();

    setUp(() {
      authCubit = MockAuthCubit();
      subject = buildTestableBlocWidget(
        routes: {
          SplashScreenPage.routeName: (_) => BlocProvider<AuthCubit>(
                create: (_) => authCubit,
                child: SplashScreenPage(),
              ),
          IntroPage.routeName: (_) => IntroPage(),
          HomePage.routeName: (_) => Scaffold(key: homePageKey),
        },
        initialRoutes: SplashScreenPage.routeName,
      );
    });

    // testWidgets(
    //     'test build AuthState.initial state should render SplashScreenPage',
    //     (tester) async {
    //   when(authCubit.state).thenAnswer((_) => AuthState.initial());

    //   await tester.pumpWidget(subject);

    //   await tester.pump();

    //   expect(find.byKey(Key(SplashScreenPage.routeName)), findsOneWidget);
    // });

    testWidgets(
        'test listen for AuthState.authenticated should navigate to HomePage',
        (tester) async {
      final finderHomePage = find.byKey(homePageKey);

      whenListen(
        authCubit,
        Stream.fromIterable(const <AuthState>[
          AuthState.initial(),
          AuthState.authenticated(),
        ]),
      );

      await tester.pumpWidget(subject);

      await tester.pumpAndSettle();

      expect(finderHomePage, findsOneWidget);
    });

    testWidgets(
        'test listen for AuthState.unauthenticated '
        'should navigate to IntroPage', (tester) async {
      final finderIntroPage = find.byKey(Key(IntroPage.routeName));

      whenListen(
        authCubit,
        Stream.fromIterable(const <AuthState>[
          AuthState.initial(),
          AuthState.unauthenticated(),
        ]),
      );

      await tester.pumpWidget(subject);

      await tester.pumpAndSettle();

      expect(finderIntroPage, findsOneWidget);
    });
  });
}
