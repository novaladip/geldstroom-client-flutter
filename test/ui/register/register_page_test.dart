import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc/register/register_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/main_button/main_button.dart'
    as main_button;
import 'package:geldstroom/ui/register/register_page.dart';
import 'package:geldstroom/ui/register/widget/register_footer.dart';
import 'package:geldstroom/ui/register/widget/register_form.dart';
import 'package:geldstroom/ui/register/widget/register_header.dart';
import 'package:geldstroom/ui/ui.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

class MockRegisterCubit extends Mock implements RegisterCubit {}

void main() {
  group(('RegisterPage'), () {
    RegisterCubit registerCubit;
    Widget subject;

    final loginPageKey = UniqueKey();
    final registerSuccessPageKey = UniqueKey();

    setUp(() {
      registerCubit = MockRegisterCubit();
      subject = buildTestableBlocWidget(
        initialRoutes: RegisterPage.routeName,
        routes: {
          RegisterPage.routeName: (_) => BlocProvider.value(
                value: registerCubit,
                child: RegisterPage(),
              ),
          RegisterSuccessPage.routeName: (_) => buildTestableWidget(
                Scaffold(key: registerSuccessPageKey),
              ),
          LoginPage.routeName: (_) => buildTestableWidget(
                Scaffold(key: loginPageKey),
              ),
        },
      );
    });

    testWidgets('render correctly', (tester) async {
      when(registerCubit.state).thenReturn(RegisterState.initial());
      await tester.pumpWidget(subject);

      expect(find.text(RegisterPage.appBarTitleText), findsOneWidget);
      expect(find.text(RegisterHeader.quotes), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text(RegisterForm.submitButtonText), findsOneWidget);
      expect(find.text(RegisterFooter.text), findsOneWidget);
    });

    testWidgets(
        'should able to pop or navigate to LoginPage by tapping the footer',
        (tester) async {
      when(registerCubit.state).thenReturn(RegisterState.initial());
      await tester.pumpWidget(subject);
      await tester.tap(find.text(RegisterFooter.text));
      await tester.pumpAndSettle();
      expect(find.byKey(loginPageKey), findsOneWidget);
    });

    testWidgets('user can input email, firstName, lastName, & password form',
        (tester) async {
      when(registerCubit.state).thenReturn(RegisterState.initial());
      await tester.pumpWidget(subject);

      final email = 'john@email.com';
      final firstName = 'john';
      final lastName = 'doe';
      final password = 'johnpassword';

      await tester.enterText(find.byKey(RegisterForm.emailInputKey), email);
      await tester.enterText(
          find.byKey(RegisterForm.firstNameInputKey), firstName);
      await tester.enterText(
          find.byKey(RegisterForm.lastNameInputKey), lastName);
      await tester.enterText(
          find.byKey(RegisterForm.passwordInputKey), password);

      expect(find.text(email), findsOneWidget);
      expect(find.text(firstName), findsOneWidget);
      expect(find.text(lastName), findsOneWidget);
      expect(find.text(password), findsOneWidget);
      await tester.tap(find.text(RegisterForm.submitButtonText));
      await tester.pumpAndSettle();
      verify(registerCubit.submit(any));
    });

    testWidgets('should show error text when user given invalid form value',
        (tester) async {
      when(registerCubit.state).thenReturn(RegisterState.initial());
      await tester.pumpWidget(subject);
      await tester.tap(find.text(RegisterForm.submitButtonText));
      await tester.pumpAndSettle();

      expect(find.text('Email is cannot be empty'), findsOneWidget);
      expect(find.text('First name is cannot be empty'), findsOneWidget);
      expect(find.text('Last name is cannot be empty'), findsOneWidget);
      expect(find.text('Password is cannot be empty'), findsOneWidget);
    });

    testWidgets(
        'submit button should show loading indicator '
        'when register state is loading', (tester) async {
      when(registerCubit.state).thenReturn(
        RegisterState(status: FormStatus.loading()),
      );
      await tester.pumpWidget(subject);
      expect(find.text(RegisterForm.submitButtonText), findsNothing);
      expect(find.byKey(main_button.MainButton.loadingIndicatorKey),
          findsOneWidget);
    });

    testWidgets('when register state is error should show an error text',
        (tester) async {
      when(registerCubit.state).thenReturn(
        RegisterState(
          status: FormStatus.error(
            error: ServerError(
              errorCode: UserErrorCode.duplicateEmail,
              message: 'Duplicate email',
            ),
          ),
        ),
      );
      await tester.pumpWidget(subject);

      expect(find.text('Duplicate email'), findsOneWidget);
    });

    testWidgets('test listen for register state error', (tester) async {
      whenListen(
        registerCubit,
        Stream.fromIterable([
          RegisterState.initial(),
          RegisterState(
            status: FormStatus.error(error: ServerError.networkError()),
          ),
        ]),
      );
      when(registerCubit.state).thenReturn(
        RegisterState(
          status: FormStatus.error(error: ServerError.networkError()),
        ),
      );
      await tester.pumpWidget(subject);
      await tester.pumpAndSettle();
      // @TODO
      // verify flushbar is show
      // expect(find.text('Register failed'), findsOneWidget);
    });

    testWidgets('test listen for register state success', (tester) async {
      whenListen(
        registerCubit,
        Stream.fromIterable([
          RegisterState.initial(),
          RegisterState(status: FormStatus.success()),
        ]),
      );
      when(registerCubit.state).thenReturn(
        RegisterState(status: FormStatus.success()),
      );
      await tester.pumpWidget(subject);
      await tester.pumpAndSettle();
      expect(find.byKey(registerSuccessPageKey), findsOneWidget);
    });
  });
}
