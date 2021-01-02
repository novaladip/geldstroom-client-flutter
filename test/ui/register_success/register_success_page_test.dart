import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/ui/login/login_page.dart';
import 'package:geldstroom/ui/register_success/register_success_page.dart';

import '../../test_helper.dart';

void main() {
  group('RegisterSuccessPage', () {
    Widget subject;
    final loginPageKey = UniqueKey();

    setUp(() {
      subject = buildTestableBlocWidget(
        routes: {
          RegisterSuccessPage.routeName: (_) => RegisterSuccessPage(),
          LoginPage.routeName: (_) => buildTestableWidget(
                Scaffold(key: loginPageKey),
              ),
        },
        initialRoutes: RegisterSuccessPage.routeName,
      );
    });

    testWidgets('render correctly', (tester) async {
      await tester.pumpWidget(subject);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.text(RegisterSuccessPage.title), findsOneWidget);
      expect(find.text(RegisterSuccessPage.subtitle), findsOneWidget);
      expect(find.text(RegisterSuccessPage.continueButtonText), findsOneWidget);

      // navigate to login page
      await tester.tap(find.text(RegisterSuccessPage.continueButtonText));
      await tester.pumpAndSettle();
      expect(find.byKey(loginPageKey), findsOneWidget);
    });
  });
}
