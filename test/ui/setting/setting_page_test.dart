import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/profile/profile_cubit.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/shared/widget/loading_indicator/loading_indicator.dart';
import 'package:geldstroom/ui/ui.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helper_tests/mock_package_info.dart';
import '../../helper_tests/profile_json.dart';
import '../../test_helper.dart';

class MockProfileCubit extends MockBloc<ProfileState> implements ProfileCubit {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  packageInfoMock();

  group('SettingPage', () {
    Widget subject;
    ProfileCubit profileCubit;
    AuthCubit authCubit;

    final profile = Profile.fromJson(profileJson);
    final serverError = ServerError.networkError();
    final profileStateLoading = ProfileState.loadInProgress();
    final profileStateSuccess = ProfileState.loadSucess(profile);
    final profileStateFailure = ProfileState.loadFailure(serverError);

    setUp(() {
      profileCubit = MockProfileCubit();
      authCubit = MockAuthCubit();

      when(profileCubit.state).thenReturn(profileStateSuccess);

      subject = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: profileCubit),
          BlocProvider.value(value: authCubit),
        ],
        child: mockNetworkImagesFor(
          () => buildTestableBlocWidget(
            routes: {
              LoginPage.routeName: (_) => Scaffold(key: Key('login_page')),
              SettingPage.routeName: (_) => SettingPage(),
              PasswordChangePage.routeName: (_) =>
                  Scaffold(key: Key('password_change_page')),
              RequestCategoryPage.routeName: (_) =>
                  Scaffold(key: Key('request_category_page')),
              CreditPage.routeName: (_) => Scaffold(key: Key('credit_page')),
            },
            initialRoutes: SettingPage.routeName,
          ),
        ),
      );
    });

    tearDown(() {
      profileCubit.close();
      authCubit.close();
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        await tester.pumpWidget(subject);
        await tester.pump();
        expect(find.byType(CircleAvatar), findsOneWidget);
        expect(find.text(profile.email), findsOneWidget);
        expect(find.text('${profile.firstName} ${profile.lastName}'),
            findsOneWidget);
        expect(find.text('Request Category'), findsOneWidget);
        expect(find.text('Credit'), findsOneWidget);
        expect(find.text('Change Password'), findsOneWidget);
        expect(find.text('1.0.0.1'), findsOneWidget);
        expect(find.text('Sign out'), findsOneWidget);
      });

      testWidgets(
          'show loading indicator when profile state is load in progress',
          (tester) async {
        when(profileCubit.state).thenReturn(profileStateLoading);
        await tester.pumpWidget(subject);
        await tester.pump();
        expect(find.byType(LoadingIndicator), findsOneWidget);
      });

      testWidgets('show error text when profile state is load failure',
          (tester) async {
        when(profileCubit.state).thenReturn(profileStateFailure);
        await tester.pumpWidget(subject);
        await tester.pump();
        expect(find.text('Failed to load profile data, pull to refresh.'),
            findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets('tap Sign out', (tester) async {
        await tester.pumpWidget(subject);
        await tester.pump();
        await tester.tap(find.text('Sign out'));
        verify(authCubit.loggedOut()).called(1);
        await tester.pumpAndSettle();
        expect(find.byKey(Key('login_page')), findsOneWidget);
      });

      testWidgets('tap Request Category', (tester) async {
        await tester.pumpWidget(subject);
        await tester.pump();
        await tester.tap(find.text('Request Category').hitTestable());
        await tester.pumpAndSettle();
        expect(find.byKey(Key('request_category_page')), findsOneWidget);
      });

      testWidgets('tap Credit', (tester) async {
        await tester.pumpWidget(subject);
        await tester.pump();
        await tester.tap(find.text('Credit').hitTestable());
        await tester.pumpAndSettle();
        expect(find.byKey(Key('credit_page')), findsOneWidget);
      });

      testWidgets('tap Change Password', (tester) async {
        await tester.pumpWidget(subject);
        await tester.pump();
        await tester.tap(find.text('Change Password').hitTestable());
        await tester.pumpAndSettle();
        expect(find.byKey(Key('password_change_page')), findsOneWidget);
      });

      testWidgets('pull to refresh', (tester) async {
        await tester.pumpWidget(subject);
        await tester.pump();
        reset(profileCubit);
        verifyNever(profileCubit.fetch());
        await tester.drag(
          find.text(profile.email),
          const Offset(0.0, 300.0),
          touchSlopY: 0,
        );
        await tester.pumpAndSettle();
        verify(profileCubit.fetch()).called(1);
      });

      testWidgets('call ProfileCubit.fetch on intiState', (tester) async {
        await tester.pumpWidget(subject);
        await tester.pump();

        verify(profileCubit.fetch()).called(1);
      });
    });
  });
}
