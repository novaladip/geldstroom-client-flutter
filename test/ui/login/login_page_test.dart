import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/network/model/status_model.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/login/widget/login_footer.dart';
import 'package:geldstroom/ui/login/widget/login_form.dart';
import 'package:geldstroom/ui/login/widget/login_header.dart';
import 'package:geldstroom/ui/ui.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

class MockLoginCubit extends MockBloc<LoginState> implements LoginCubit {}

void main() {
  group('LoginPage', () {
    AuthCubit authCubit;
    LoginCubit loginCubit;
    Widget subject;
    final registerPageKey = UniqueKey();
    final resetPasswordPageKey = UniqueKey();
    final homePageKey = UniqueKey();

    setUpAll(() {
      authCubit = MockAuthCubit();
      loginCubit = MockLoginCubit();
      subject = buildTestableBlocWidget(
        initialRoutes: LoginPage.routeName,
        routes: {
          RegisterPage.routeName: (_) =>
              buildTestableWidget(Scaffold(key: registerPageKey)),
          OverviewPage.routeName: (_) => Scaffold(key: homePageKey),
          LoginPage.routeName: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: authCubit),
                  BlocProvider.value(value: loginCubit),
                ],
                child: LoginPage(),
              ),
          ResetPasswordPage.routeName: (_) =>
              buildTestableWidget(Scaffold(key: resetPasswordPageKey)),
        },
      );
    });

    testWidgets('should render LoginPage correctly on initial state',
        (tester) async {
      when(loginCubit.state).thenAnswer((_) => LoginState.initial());

      await tester.pumpWidget(subject);

      // Header
      expect(find.text(loginHeaderTitle), findsOneWidget);
      expect(find.text(loginHeaderSubtitle), findsOneWidget);

      // Form
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text(LoginForm.submitButtonText), findsOneWidget);
      expect(find.text(LoginForm.forgotPasswordText), findsOneWidget);

      // Footer
      expect(find.text(loginFooterText), findsOneWidget);
      expect(find.text(loginFooterText2), findsOneWidget);

      // Navigate to RegisterPage
      await tester.tap(find.text(loginFooterText2));
      await tester.pumpAndSettle();
      expect(find.byKey(registerPageKey), findsOneWidget);
    });

    testWidgets('should able navigate to ResetPasswordPage', (tester) async {
      when(loginCubit.state).thenAnswer((_) => LoginState.initial());

      await tester.pumpWidget(subject);

      expect(find.text(LoginForm.forgotPasswordText), findsOneWidget);

      // Navigate to ResetPasswordPage
      await tester.tap(find.text(LoginForm.forgotPasswordText));
      await tester.pumpAndSettle();
      expect(find.byKey(resetPasswordPageKey), findsOneWidget);
    });

    testWidgets(
        'should render an error text when user submit an empty form '
        'should render an error text when user submit an invalid form value',
        (tester) async {
      when(loginCubit.state).thenAnswer((_) => LoginState.initial());

      await tester.pumpWidget(subject);

      final invalidEmail = 'johnemail.com';

      final emailInput = find.byKey(LoginForm.emailInputKey);
      final passwordInput = find.byKey(LoginForm.passwordInputKey);
      final submitButton = find.byKey(LoginForm.submitButtonKey);

      expect(emailInput, findsOneWidget);
      expect(passwordInput, findsOneWidget);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pump();
      expect(find.text('Email is cannot be empty'), findsOneWidget);
      expect(find.text('Password is cannot be empty'), findsOneWidget);

      await tester.tap(emailInput);
      await tester.enterText(emailInput, invalidEmail);
      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets(
        'when LoginState is error with error code user not found'
        'should show error text', (tester) async {
      when(loginCubit.state).thenReturn(
        LoginState(
          status: FormStatus.error(
            error: ServerError(
              errorCode: UserErrorCode.userNotFound,
              message: 'User not found',
            ),
          ),
        ),
      );
      await tester.pumpWidget(subject);
      expect(find.text('User not found'), findsOneWidget);
    });

    testWidgets(
        'when LoginState is error with error code invalid credentials '
        'should show error text', (tester) async {
      when(loginCubit.state).thenReturn(
        LoginState(
          status: FormStatus.error(
            error: ServerError(
              errorCode: UserErrorCode.invalidCredentials,
              message: 'Invalid credentials',
            ),
          ),
        ),
      );

      await tester.pumpWidget(subject);
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets(
        'when state is loading, should disable submit button '
        'and show loading indicator', (tester) async {
      when(loginCubit.state)
          .thenReturn(LoginState(status: FormStatus.loading()));
      await tester.pumpWidget(subject);
      final email = 'john@email.com';
      final password = 'johnpassword';

      final emailInput = find.byKey(LoginForm.emailInputKey);
      final passwordInput = find.byKey(LoginForm.passwordInputKey);
      final submitButton = find.byKey(LoginForm.submitButtonKey);

      verifyNever(loginCubit.submit(any));

      await tester.enterText(emailInput, email);
      await tester.enterText(passwordInput, password);
      await tester.tap(submitButton);
      verifyNever(loginCubit.submit(any));

      expect(find.byKey(MainButton.loadingIndicatorKey), findsOneWidget);
    });

    testWidgets('when submit button pressed should execute loginCubit.submit()',
        (tester) async {
      when(loginCubit.state).thenReturn(LoginState.initial());

      await tester.pumpWidget(subject);

      final email = 'john@email.com';
      final password = 'johnpassword';

      final emailInput = find.byKey(LoginForm.emailInputKey);
      final passwordInput = find.byKey(LoginForm.passwordInputKey);
      final submitButton = find.byKey(LoginForm.submitButtonKey);

      verifyNever(loginCubit.submit(any));

      await tester.enterText(emailInput, email);
      await tester.enterText(passwordInput, password);
      await tester.tap(submitButton);

      verify(loginCubit.submit(any)).called(1);
    });

    testWidgets(
        'listen for LoginState, should show a snackbar when status is error',
        (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          LoginState(status: FormStatus.loading()),
          LoginState(
            status: FormStatus.error(error: ServerError.networkError()),
          ),
          LoginState(status: FormStatus.success()),
        ]),
      );
      when(loginCubit.state).thenReturn(
        LoginState(
          status: FormStatus.error(
            error: ServerError.networkError(),
          ),
        ),
      );
      await tester.pumpWidget(subject);
      await tester.pumpAndSettle(Duration(milliseconds: 1000));
      // @TODO
      // expect(find.text('Login Failed'), findsOneWidget);
      // expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets(
        'when LoginState status is loading '
        'submit button must be disabled and show loading indicator',
        (tester) async {
      when(loginCubit.state)
          .thenReturn(LoginState(status: FormStatus.loading()));
      await tester.pumpWidget(subject);

      expect(find.byKey(MainButton.loadingIndicatorKey), findsOneWidget);
    });

    testWidgets(
        'listen for AuthState, should navigate to HomePage '
        'when AuthState.authenticated()', (tester) async {
      when(loginCubit.state).thenAnswer((_) => LoginState.initial());
      whenListen(
        authCubit,
        Stream.fromIterable(<AuthState>[
          AuthState.authenticated(),
        ]),
      );

      await tester.pumpWidget(subject);
      await tester.pumpAndSettle();
      expect(find.byKey(homePageKey), findsOneWidget);
    });
  });
}
