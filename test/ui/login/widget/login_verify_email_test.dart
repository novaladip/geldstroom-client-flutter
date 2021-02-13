import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/resend_email_verification/resend_email_verification_cubit.dart';
import 'package:geldstroom/core/bloc_base/form_none/form_none_cubit.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/shared/widget/main_button/main_button.dart';
import 'package:geldstroom/ui/login/widget/login_verify_email.dart';
import 'package:mockito/mockito.dart';

import '../../../test_helper.dart';

class MockResendEmailVerificationCubit extends MockBloc<FormNoneState>
    implements ResendEmailVerificationCubit {}

void main() {
  group('LoginVerifyEmail', () {
    ResendEmailVerificationCubit resendEmailVerificationCubit;
    Widget subject;

    final email = 'john@email.com';
    final serverError = ServerError.unknownError();
    final stateInitial = FormNoneState.initial();
    final stateLoading = stateInitial.copyWith(status: FormStatus.loading());
    final stateError =
        stateInitial.copyWith(status: FormStatus.error(error: serverError));
    final stateSuccess = stateInitial.copyWith(status: FormStatus.success());

    setUp(() {
      resendEmailVerificationCubit = MockResendEmailVerificationCubit();
      when(resendEmailVerificationCubit.state).thenReturn(stateInitial);
      subject = buildTestableWidget(
        BlocProvider.value(
          value: resendEmailVerificationCubit,
          child: LoginVerifyEmail(email: email),
        ),
      );
    });

    tearDown(() {
      resendEmailVerificationCubit.close();
    });

    group('renders', () {
      testWidgets('correctly on initial state', (tester) async {
        await tester.pumpWidget(subject);

        expect(find.byType(SvgPicture), findsOneWidget);
        expect(find.text('$email is not verified yet'), findsOneWidget);

        // submit button
        expect(find.byType(MainButton), findsOneWidget);
        // button title
        expect(find.text('Send Email Verification'), findsOneWidget);
        expect(find.text('Close'), findsNothing);
        // button loading indicator
        expect(find.byKey(MainButton.loadingIndicatorKey), findsNothing);
        // should able to tap submit button
        await tester.tap(find.byType(MainButton).hitTestable());
        verify(resendEmailVerificationCubit.submit(email)).called(1);
      });

      testWidgets('correctly on loading state', (tester) async {
        when(resendEmailVerificationCubit.state).thenReturn(stateLoading);
        await tester.pumpWidget(subject);

        expect(find.byType(SvgPicture), findsOneWidget);
        expect(find.text('$email is not verified yet'), findsOneWidget);

        // submit button
        expect(find.byType(MainButton), findsOneWidget);
        // button title
        expect(find.text('Send Email Verification'), findsNothing);
        expect(find.text('Close'), findsNothing);
        // button loading indicator
        expect(find.byKey(MainButton.loadingIndicatorKey), findsOneWidget);

        // should not able to tap submit button
        await tester.tap(find.byType(MainButton));
        verifyNever(resendEmailVerificationCubit.submit(email));
      });
    });

    group('listen for ResendEmailVerificationCubit', () {
      testWidgets('when state change to success state', (tester) async {
        when(resendEmailVerificationCubit.state).thenReturn(stateSuccess);
        whenListen(
          resendEmailVerificationCubit,
          Stream.fromIterable([stateLoading, stateSuccess]),
        );
        await tester.pumpWidget(subject);
        await tester.pumpAndSettle();

        // should show snackbar with success message
        expect(
          find.text('An verification link has been send to your email'),
          findsOneWidget,
        );

        // hide default submit button title
        expect(find.text('Send Email Verification'), findsNothing);

        // submit button title should change to 'Close'
        expect(find.text('Close'), findsOneWidget);

        // tap to close current page
        await tester.tap(find.text('Close').hitTestable());
      });

      testWidgets('when state changed to error state', (tester) async {
        when(resendEmailVerificationCubit.state).thenReturn(stateSuccess);
        whenListen(
          resendEmailVerificationCubit,
          Stream.fromIterable([stateLoading, stateError]),
        );
        await tester.pumpWidget(subject);
        await tester.pumpAndSettle();

        // should show snackbar with error message
        expect(
          find.text(serverError.message),
          findsOneWidget,
        );
      });
    });

    group('calls', () {
      testWidgets('resendEmailVerificationCubit.clear on init state',
          (tester) async {
        when(resendEmailVerificationCubit.state).thenReturn(stateSuccess);

        await tester.pumpWidget(subject);

        verify(resendEmailVerificationCubit.clear()).called(1);
      });
    });
  });
}
