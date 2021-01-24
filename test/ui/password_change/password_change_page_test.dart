import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/password_change/password_change_cubit.dart';
import 'package:geldstroom/core/network/dto/dto.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/password_change/widgets/password_change_form.dart';
import 'package:geldstroom/ui/password_change/widgets/password_change_header.dart';
import 'package:geldstroom/ui/ui.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

class MockPasswordChangeCubit extends MockBloc<PasswordChangeState>
    implements PasswordChangeCubit {}

void main() {
  group('PasswordChangePage', () {
    PasswordChangeCubit passwordChangeCubit;
    Widget subject;

    final serverError = ServerError.fromJson({
      'message': 'Validation error',
      'errorCode': 'USER_400',
      'error': {
        'oldPassword': 'Invalid old password',
        'password': 'Invalid password',
        'passwordConfirmation': 'Invalid password confirmation',
      }
    });
    final stateIdle = PasswordChangeState(FormStatus.idle());
    final stateLoading = PasswordChangeState(FormStatus.loading());
    final stateSuccess = PasswordChangeState(FormStatus.success());
    final stateError =
        PasswordChangeState(FormStatus.error(error: serverError));

    setUp(() {
      passwordChangeCubit = MockPasswordChangeCubit();
      subject = buildTestableWidget(
        BlocProvider.value(
          value: passwordChangeCubit,
          child: PasswordChangePage(),
        ),
      );
    });

    tearDown(() {
      passwordChangeCubit.close();
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        when(passwordChangeCubit.state).thenReturn(stateIdle);
        await tester.pumpWidget(subject);

        // Header
        expect(find.byType(Icon), findsNothing); // back button
        expect(find.text(PasswordChangeHeader.title), findsOneWidget);
        expect(find.text(PasswordChangeHeader.subtitle), findsOneWidget);

        // Form
        expect(find.text('Old Password'), findsOneWidget);
        expect(find.text('New Password'), findsOneWidget);
        expect(find.text('New Password Confirmation'), findsOneWidget);
        expect(find.text('Submit'), findsOneWidget);
      });

      testWidgets('when status is loading', (tester) async {
        when(passwordChangeCubit.state).thenReturn(stateLoading);
        await tester.pumpWidget(subject);

        // Header
        expect(find.byType(Icon), findsNothing); // back button
        expect(find.text(PasswordChangeHeader.title), findsOneWidget);
        expect(find.text(PasswordChangeHeader.subtitle), findsOneWidget);

        // Form
        expect(find.text('Old Password'), findsOneWidget);
        expect(find.text('New Password'), findsOneWidget);
        expect(find.text('New Password Confirmation'), findsOneWidget);

        expect(find.text('Submit'), findsNothing);
        expect(find.byKey(MainButton.loadingIndicatorKey), findsOneWidget);
      });

      testWidgets('when status is error', (tester) async {
        when(passwordChangeCubit.state).thenReturn(stateError);
        await tester.pumpWidget(subject);

        // Header
        expect(find.byType(Icon), findsNothing); // back button
        expect(find.text(PasswordChangeHeader.title), findsOneWidget);
        expect(find.text(PasswordChangeHeader.subtitle), findsOneWidget);

        // Form
        expect(find.text('Old Password'), findsOneWidget);
        expect(find.text('New Password'), findsOneWidget);
        expect(find.text('New Password Confirmation'), findsOneWidget);
        expect(find.text('Submit'), findsOneWidget);

        // Error text
        expect(find.text(serverError.error['oldPassword']), findsOneWidget);
        expect(find.text(serverError.error['password']), findsOneWidget);
        expect(
          find.text(serverError.error['passwordConfirmation']),
          findsOneWidget,
        );
      });
    });
    group('listen', () {
      testWidgets('when status is error', (tester) async {
        whenListen(passwordChangeCubit, Stream.fromIterable([stateError]));
        when(passwordChangeCubit.state).thenReturn(stateError);
        await tester.pumpWidget(subject);
        await tester.pump(Duration(milliseconds: 100));
        expect(find.text(serverError.message), findsOneWidget);
      });

      testWidgets('when status is success', (tester) async {
        whenListen(passwordChangeCubit, Stream.fromIterable([stateSuccess]));
        when(passwordChangeCubit.state).thenReturn(stateSuccess);
        await tester.pumpWidget(subject);
        await tester.pump(Duration(milliseconds: 100));
        // @TODO
      });

      testWidgets('do nothing when status is not success or error',
          (tester) async {
        whenListen(passwordChangeCubit, Stream.fromIterable([stateLoading]));
        when(passwordChangeCubit.state).thenReturn(stateSuccess);
        await tester.pumpWidget(subject);
      });
    });
    group('calls', () {
      testWidgets('submitting a valid value', (tester) async {
        when(passwordChangeCubit.state).thenReturn(stateIdle);
        await tester.pumpWidget(subject);

        final dto = PasswordChangeDto(
          oldPassword: '123123',
          password: '321321',
          passwordConfirmation: '321321',
        );

        await tester.enterText(
          find.byKey(PasswordChangeForm.oldPasswordKey),
          dto.oldPassword,
        );
        await tester.enterText(
          find.byKey(PasswordChangeForm.passwordKey),
          dto.password,
        );

        await tester.enterText(
          find.byKey(PasswordChangeForm.password2Key),
          dto.passwordConfirmation,
        );

        // tap the submit
        await tester.tap(find.text('Submit').hitTestable());
        verify(passwordChangeCubit.submit(dto)).called(1);
      });

      testWidgets('submitting an invalid value', (tester) async {
        when(passwordChangeCubit.state).thenReturn(stateIdle);
        await tester.pumpWidget(subject);

        await tester.enterText(
          find.byKey(PasswordChangeForm.password2Key),
          'getupandfight',
        );

        // tap the submit
        await tester.tap(find.text('Submit').hitTestable());
        verifyNever(passwordChangeCubit.submit(any));
        await tester.pump();
        expect(find.text('Old password is cannot be empty'), findsOneWidget);
        expect(find.text('Password is cannot be empty'), findsOneWidget);
        expect(find.text('Invalid Password confirmation'), findsOneWidget);
      });
    });
  });
}
