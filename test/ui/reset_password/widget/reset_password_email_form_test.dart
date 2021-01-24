import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';
import 'package:geldstroom/core/bloc/request_otp/request_otp_cubit.dart';
import 'package:geldstroom/ui/reset_password/widget/reset_password_email_form.dart';

import '../../../test_helper.dart';

class MockRequestOtpCubit extends MockBloc<RequestOtpState>
    implements RequestOtpCubit {}

class MockResetPasswordCubit extends MockBloc<PasswordResetState>
    implements PasswordResetCubit {}

void main() {
  group('ResetPasswordEmailForm', () {
    PasswordResetCubit passwordResetCubit;
    RequestOtpCubit requestOtpCubit;

    setUp(() {
      passwordResetCubit = MockResetPasswordCubit();
      requestOtpCubit = MockRequestOtpCubit();
    });

    tearDown(() {
      passwordResetCubit.close();
    });

    testWidgets('renders correctly', (tester) async {
      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      when(requestOtpCubit.state).thenReturn(RequestOtpState.initial());
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: requestOtpCubit),
              BlocProvider.value(value: passwordResetCubit),
            ],
            child: ResetPasswordEmailForm(controller: controller),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
      await tester.tap(find.text('Send'));
      await tester.pump();
      expect(find.text('Email is cannot be empty'), findsOneWidget);
    });

    testWidgets('should show error text when RequestOtpState is error',
        (tester) async {
      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      when(requestOtpCubit.state).thenReturn(
        RequestOtpState(
          status: FormStatus.error(
            error: ServerError(
              errorCode: UserErrorCode.userNotFound,
              message: 'User not found',
            ),
          ),
        ),
      );
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: requestOtpCubit),
              BlocProvider.value(value: passwordResetCubit),
            ],
            child: ResetPasswordEmailForm(controller: controller),
          ),
        ),
      );

      expect(find.text('User not found'), findsOneWidget);
    });

    testWidgets('should show error text when RequestOtpState is error',
        (tester) async {
      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      when(requestOtpCubit.state).thenReturn(
        RequestOtpState(
          status: FormStatus.error(
            error: ServerError(
              errorCode: UserErrorCode.userNotFound,
              message: 'User not found',
            ),
          ),
        ),
      );
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: requestOtpCubit),
              BlocProvider.value(value: passwordResetCubit),
            ],
            child: ResetPasswordEmailForm(controller: controller),
          ),
        ),
      );

      expect(find.text('User not found'), findsOneWidget);
    });

    testWidgets('should show error text when PasswordResetState is error',
        (tester) async {
      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      when(requestOtpCubit.state).thenReturn(
        RequestOtpState(
          status: FormStatus.error(
            error: ServerError(
              errorCode: UserErrorCode.userNotFound,
              message: 'User not found',
            ),
          ),
        ),
      );
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: requestOtpCubit),
              BlocProvider.value(value: passwordResetCubit),
            ],
            child: ResetPasswordEmailForm(controller: controller),
          ),
        ),
      );

      expect(find.text('User not found'), findsOneWidget);
    });

    testWidgets('should show loading indicator when RequestOtpState is loading',
        (tester) async {
      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      when(requestOtpCubit.state).thenReturn(
        RequestOtpState(status: FormStatus.loading()),
      );
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: requestOtpCubit),
              BlocProvider.value(value: passwordResetCubit),
            ],
            child: ResetPasswordEmailForm(controller: controller),
          ),
        ),
      );

      expect(find.text('Resend'), findsNothing);
      expect(find.text('Send'), findsNothing);
      expect(
        find.byKey(ResetPasswordEmailForm.loadingKey),
        findsOneWidget,
      );
    });

    testWidgets('should able to enter text to email form', (tester) async {
      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      when(requestOtpCubit.state).thenReturn(RequestOtpState.initial());
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: requestOtpCubit),
              BlocProvider.value(value: passwordResetCubit),
            ],
            child: ResetPasswordEmailForm(controller: controller),
          ),
        ),
      );

      final email = 'john@email.com';
      final emailForm = find.byKey(
        ResetPasswordEmailForm.emailInputKey,
      );

      // Simulate enter text
      await tester.enterText(emailForm, email);
      await tester.pump();
      expect(find.text(email), findsOneWidget);

      // Tap send button
      await tester.tap(find.text('Send'));
      verify(requestOtpCubit.submit(email));
    });

    testWidgets('should show error text when user submitting an invalid email',
        (tester) async {
      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      when(requestOtpCubit.state).thenReturn(RequestOtpState.initial());
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: requestOtpCubit),
              BlocProvider.value(value: passwordResetCubit),
            ],
            child: ResetPasswordEmailForm(controller: controller),
          ),
        ),
      );

      final email = 'john@emailom';
      final emailForm = find.byKey(
        ResetPasswordEmailForm.emailInputKey,
      );

      // Simulate enter text
      await tester.enterText(emailForm, email);
      await tester.pump();
      expect(find.text(email), findsOneWidget);

      // Tap send button
      await tester.tap(find.text('Send'));
      verifyNever(requestOtpCubit.submit(any));

      await tester.pump();
      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets('listen RequestOtpState when state is success', (tester) async {
      whenListen<RequestOtpState>(
        requestOtpCubit,
        Stream.fromIterable([
          RequestOtpState.initial(),
          RequestOtpState(status: FormStatus.loading()),
          RequestOtpState(status: FormStatus.success()),
        ]),
      );

      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      when(requestOtpCubit.state).thenReturn(
        RequestOtpState(status: FormStatus.success()),
      );
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: requestOtpCubit),
              BlocProvider.value(value: passwordResetCubit),
            ],
            child: ResetPasswordEmailForm(controller: controller),
          ),
        ),
      );

      await tester.pump();

      // verify snackbar is show up
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Code OTP has been send to your email'),
        findsOneWidget,
      );

      // verify timer
      expect(find.text('30'), findsOneWidget);
      await tester.pump(Duration(seconds: 30));
      expect(find.text('Resend'), findsOneWidget);
    });

    testWidgets('listen RequestOtpState when state is error', (tester) async {
      final serverError = ServerError(
        errorCode: UserErrorCode.userNotFound,
        message: 'User not found',
      );

      whenListen<RequestOtpState>(
        requestOtpCubit,
        Stream.fromIterable([
          RequestOtpState.initial(),
          RequestOtpState(status: FormStatus.loading()),
          RequestOtpState(status: FormStatus.error(error: serverError)),
        ]),
      );

      when(passwordResetCubit.state).thenReturn(PasswordResetState.initial());
      when(requestOtpCubit.state).thenReturn(
        RequestOtpState(status: FormStatus.error(error: serverError)),
      );
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestableWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: requestOtpCubit),
              BlocProvider.value(value: passwordResetCubit),
            ],
            child: ResetPasswordEmailForm(controller: controller),
          ),
        ),
      );

      await tester.pump();

      // verify snackbar is show up
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text(serverError.message), findsNWidgets(2));

      // verify timer
      expect(find.text('30'), findsOneWidget);
      await tester.pump(Duration(seconds: 30));
      expect(find.text('Resend'), findsOneWidget);
    });
  });
}
