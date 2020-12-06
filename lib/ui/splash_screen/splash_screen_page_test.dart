import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../core/bloc/auth/auth_cubit.dart';
import '../../test_helper.dart';
import '../ui.dart';

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  group('SplashScreenPage()', () {
    AuthCubit mockAuthCubit;
    Widget subject;

    setUp(() {
      mockAuthCubit = MockAuthCubit();
      subject = buildTestableWidget(
        BlocProvider.value(
          value: mockAuthCubit,
          child: AppWrapper(SplashScreenPage()),
        ),
      );
    });

    testWidgets(
        'test build AuthState.initial state should render SplashScreenPage',
        (tester) async {
      when(mockAuthCubit.state).thenAnswer((_) => AuthState.initial());

      await tester.pumpWidget(subject);

      await tester.pump();

      expect(find.byKey(Key(SplashScreenPage.routeName)), findsOneWidget);
    });

    testWidgets(
        'test listen for AuthState.authenticated should navigate to HomePage',
        (tester) async {
      final finderHomePage = find.byKey(Key(HomePage.routeName));

      whenListen(
        mockAuthCubit,
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
        mockAuthCubit,
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
