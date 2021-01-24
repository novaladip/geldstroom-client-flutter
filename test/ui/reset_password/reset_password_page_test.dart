import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc/request_otp/request_otp_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/ui/reset_password/widget/reset_password_email_form.dart';
import 'package:geldstroom/ui/reset_password/widget/reset_password_form.dart';
import 'package:geldstroom/ui/reset_password/widget/reset_password_success.dart';
import 'package:geldstroom/ui/ui.dart';
import 'package:mockito/mockito.dart';
import 'package:geldstroom/shared/widget/main_button/main_button.dart'
    as main_button;

import '../../test_helper.dart';

class MockRequestOtpCubit extends MockBloc<RequestOtpState>
    implements RequestOtpCubit {}

class MockResetPasswordCubit extends MockBloc<PasswordResetState>
    implements PasswordResetCubit {}

void main() {
  group('ResetPasswordPage', () {
    const loginPageKey = Key('login_page');
    Widget subject;
    PasswordResetCubit passwordResetCubit;
    RequestOtpCubit requestOtpCubit;

    setUp(() {
      passwordResetCubit = MockResetPasswordCubit();
      requestOtpCubit = MockRequestOtpCubit();
      subject = buildTestableBlocWidget(
        initialRoutes: ResetPasswordPage.routeName,
        routes: {
          LoginPage.routeName: (_) => buildTestableWidget(
                Scaffold(key: loginPageKey),
              ),
          ResetPasswordPage.routeName: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: passwordResetCubit),
                  BlocProvider.value(value: requestOtpCubit),
                ],
                child: ResetPasswordPage(),
              ),
        },
      );
    });

    testWidgets('ResetPasswordPage render correctly', (tester) async {
      when(requestOtpCubit.state).thenReturn(RequestOtpState.initial());
      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      await tester.pumpWidget(subject);

      expect(find.text(ResetPasswordPage.appBarTitle), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
      expect(find.text('OTP'), findsNothing);
      expect(find.text('Password'), findsNothing);
      expect(find.text('Password Confirmation'), findsNothing);
      expect(find.text(ResetPasswordForm.submitButtonText), findsNothing);
    });

    testWidgets(
        'should show all text form field and submit button '
        'when requestOtp success', (tester) async {
      whenListen(
        requestOtpCubit,
        Stream.fromIterable([
          RequestOtpState(status: FormStatus.idle()),
          RequestOtpState(status: FormStatus.loading()),
          RequestOtpState(status: FormStatus.success())
        ]),
      );
      when(requestOtpCubit.state)
          .thenReturn(RequestOtpState(status: FormStatus.success()));
      when(passwordResetCubit.state).thenReturn(
        PasswordResetState(
          status: FormStatus.idle(),
          showAllForm: true,
        ),
      );
      await tester.pumpWidget(subject);
      await tester.pumpAndSettle(Duration(seconds: 1));

      expect(find.text(ResetPasswordPage.appBarTitle), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Resend'), findsNothing);
      expect(find.text('Send'), findsNothing);
      expect(find.text('OTP'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Password Confirmation'), findsOneWidget);
      expect(find.text(ResetPasswordForm.submitButtonText), findsOneWidget);
    });

    testWidgets(
        'should able to enter text form field and tap the submit button ',
        (tester) async {
      whenListen(
        requestOtpCubit,
        Stream.fromIterable([
          RequestOtpState(status: FormStatus.idle()),
          RequestOtpState(status: FormStatus.loading()),
          RequestOtpState(status: FormStatus.success())
        ]),
      );
      when(requestOtpCubit.state)
          .thenReturn(RequestOtpState(status: FormStatus.success()));
      when(passwordResetCubit.state).thenReturn(
        PasswordResetState(
          status: FormStatus.idle(),
          showAllForm: true,
        ),
      );
      await tester.pumpWidget(subject);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final dto = PasswordResetDto(
        email: 'john@email.com',
        password: 'johnpassword',
        otp: '123456',
      );

      final emailInput = find.byKey(ResetPasswordEmailForm.emailInputKey);
      final otpInput = find.byKey(ResetPasswordForm.otpInputKey);
      final passwordInput = find.byKey(ResetPasswordForm.passwordInputKey);
      final password2Input = find.byKey(ResetPasswordForm.password2InputKey);
      final submitButton = find.text(ResetPasswordForm.submitButtonText);

      await tester.enterText(emailInput, dto.email);
      await tester.enterText(otpInput, dto.otp);
      await tester.enterText(passwordInput, dto.password);
      await tester.enterText(password2Input, dto.password);
      await tester.tap(submitButton);
      verify(passwordResetCubit.submit(any));
    });

    testWidgets('should show error text when given invalid input',
        (tester) async {
      whenListen(
        requestOtpCubit,
        Stream.fromIterable([
          RequestOtpState(status: FormStatus.idle()),
          RequestOtpState(status: FormStatus.loading()),
          RequestOtpState(status: FormStatus.success())
        ]),
      );
      when(requestOtpCubit.state)
          .thenReturn(RequestOtpState(status: FormStatus.success()));
      when(passwordResetCubit.state).thenReturn(
        PasswordResetState(
          status: FormStatus.idle(),
          showAllForm: true,
        ),
      );
      await tester.pumpWidget(subject);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final dto = PasswordResetDto(
        email: 'john',
        password: '',
        otp: '',
      );

      final emailInput = find.byKey(ResetPasswordEmailForm.emailInputKey);
      final otpInput = find.byKey(ResetPasswordForm.otpInputKey);
      final passwordInput = find.byKey(ResetPasswordForm.passwordInputKey);
      final password2Input = find.byKey(ResetPasswordForm.password2InputKey);
      final submitButton = find.text(ResetPasswordForm.submitButtonText);

      await tester.enterText(emailInput, dto.email);
      await tester.enterText(otpInput, dto.otp);
      await tester.enterText(passwordInput, dto.password);
      await tester.enterText(password2Input, dto.password);
      await tester.tap(submitButton);
      verifyNever(passwordResetCubit.submit(any));

      await tester.pumpAndSettle();

      expect(find.text('Invalid email address'), findsOneWidget);
      expect(find.text('OTP is cannot be empty'), findsOneWidget);
      expect(find.text('Password is cannot be empty'), findsOneWidget);
    });

    testWidgets(
        'should show error text when PasswordResetState status is error',
        (tester) async {
      final error = ServerError(
        errorCode: '2313',
        message: 'Validation failed',
        error: {
          'OTP': 'Invalid OTP',
          'password': 'Password is cannot be empty',
        },
      );

      whenListen(
        requestOtpCubit,
        Stream.fromIterable([
          RequestOtpState(status: FormStatus.idle()),
          RequestOtpState(status: FormStatus.loading()),
          RequestOtpState(status: FormStatus.success())
        ]),
      );
      whenListen(
        passwordResetCubit,
        Stream.fromIterable([
          PasswordResetState(status: FormStatus.loading()),
          PasswordResetState(
            status: FormStatus.error(error: error),
            showAllForm: true,
          ),
        ]),
      );
      when(requestOtpCubit.state)
          .thenReturn(RequestOtpState(status: FormStatus.success()));
      when(passwordResetCubit.state).thenReturn(
        PasswordResetState(
          status: FormStatus.error(error: error),
          showAllForm: true,
        ),
      );

      await tester.pumpWidget(subject);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text(error.error['OTP']), findsOneWidget);
      expect(find.text(error.error['password']), findsOneWidget);
    });

    testWidgets(
        'should show loading indicator on submit button '
        'when PasswordResetState status is loading', (tester) async {
      when(passwordResetCubit.state).thenReturn(
        PasswordResetState(
          status: FormStatus.loading(),
          showAllForm: true,
        ),
      );
      when(requestOtpCubit.state)
          .thenReturn(RequestOtpState(status: FormStatus.idle()));

      await tester.pumpWidget(subject);

      expect(find.byKey(main_button.MainButton.titleKey), findsNothing);
      expect(
        find.byKey(main_button.MainButton.loadingIndicatorKey),
        findsOneWidget,
      );
    });

    testWidgets(
        'listen for RequestOtpState should show snackbar when status is error',
        (tester) async {
      final serverError = ServerError(
        errorCode: UserErrorCode.userNotFound,
        message: 'User not found',
      );

      whenListen(
        requestOtpCubit,
        Stream.fromIterable([
          RequestOtpState.initial(),
          RequestOtpState(
            status: FormStatus.error(error: serverError),
          ),
        ]),
      );

      when(passwordResetCubit.state).thenReturn(
        PasswordResetState(
          status: FormStatus.loading(),
          showAllForm: true,
        ),
      );
      when(requestOtpCubit.state).thenReturn(
        RequestOtpState(
          status: FormStatus.error(error: serverError),
        ),
      );

      await tester.pumpWidget(subject);
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('User not found'), findsNWidgets(2));
    });

    testWidgets(
        'listen for PasswordResetState, when state is success '
        'should show ResetPasswordSuccess', (tester) async {
      whenListen(
        passwordResetCubit,
        Stream.fromIterable([
          PasswordResetState.initial(),
          PasswordResetState(status: FormStatus.loading()),
          PasswordResetState(status: FormStatus.success()),
        ]),
      );
      when(passwordResetCubit.state)
          .thenReturn(PasswordResetState(status: FormStatus.success()));
      when(requestOtpCubit.state)
          .thenReturn(RequestOtpState(status: FormStatus.success()));

      await tester.pumpWidget(subject);
      await tester.pumpAndSettle();
      expect(find.text(ResetPasswordSuccess.title), findsOneWidget);
      expect(find.text(ResetPasswordSuccess.subtitle), findsOneWidget);
      expect(
        find.text(ResetPasswordSuccess.continueButtonText),
        findsOneWidget,
      );

      // tap continue button
      await tester.tap(find.text(ResetPasswordSuccess.continueButtonText));
      await tester.pumpAndSettle();
      expect(find.byKey(loginPageKey), findsOneWidget);
    });
  });
}
