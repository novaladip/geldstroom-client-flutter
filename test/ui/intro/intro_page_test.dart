import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/ui/intro/intro_page.dart';
import 'package:geldstroom/ui/login/login_page.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

class MockLoginCubit extends MockBloc<LoginState> implements LoginCubit {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  group('IntroPage', () {
    Widget subject;
    LoginCubit loginCubit;
    AuthCubit authCubit;

    setUp(() {
      loginCubit = MockLoginCubit();
      authCubit = MockAuthCubit();

      subject = buildTestableBlocWidget(
        initialRoutes: IntroPage.routeName,
        routes: {
          IntroPage.routeName: (_) => IntroPage(),
          LoginPage.routeName: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: authCubit),
                  BlocProvider.value(value: loginCubit),
                ],
                child: LoginPage(),
              )
        },
      );
    });

    test('IntroContent ', () {
      final introContent = IntroContent(
        title: 'Lorem',
        body: 'Ipsum',
        image: '/assets/img',
      );
      expect(introContent.title, 'Lorem');
      expect(introContent.body, 'Ipsum');
      expect(introContent.image, '/assets/img');
    });

    testWidgets('should render intro content correctly', (tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(subject),
      );

      expect(find.text(kSkipButtonText), findsOneWidget);
      expect(find.text(kNextButtonText), findsOneWidget);

      // verify the content changes after tapping the next button
      for (var i = 0; i < kIntroContents.length; i++) {
        final content = kIntroContents[i];
        expect(find.text(content.title), findsOneWidget);
        expect(find.text(content.body), findsOneWidget);

        if (i != kIntroContents.length - 1) {
          // tapping the next button
          await tester.tap(find.text(kNextButtonText));
          await tester.pumpAndSettle();
        } else {
          // if were on the last content pages, should render the done button
          expect(find.text(kDoneButtonText), findsOneWidget);

          when(loginCubit.state).thenAnswer((_) => LoginState.initial());
          // tap the done button and verify login page appear
          await tester.tap(find.text(kDoneButtonText));
          await tester.pumpAndSettle();
          expect(find.byKey(loginPageKey), findsOneWidget);
        }
      }
    });

    testWidgets('should jump to last intro content when skip button pressed',
        (tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(subject),
      );

      await tester.tap(find.text(kSkipButtonText));
      await tester.pumpAndSettle();

      final lastContent = kIntroContents.last;

      expect(find.text(lastContent.title), findsOneWidget);
      expect(find.text(lastContent.body), findsOneWidget);
    });
  });
}
