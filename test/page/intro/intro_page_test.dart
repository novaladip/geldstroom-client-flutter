import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/page/intro/intro_page.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../test_helper.dart';

void main() {
  group('IntroPage', () {
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
        () => tester.pumpWidget(
          AppWrapper(IntroPage()),
        ),
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

          // @TODO tap the done button and verify LoginPage is pushed
        }
      }
    });

    testWidgets('should jump to last intro content when skip button pressed',
        (tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpWidget(
          AppWrapper(IntroPage()),
        ),
      );

      await tester.tap(find.text(kSkipButtonText));
      await tester.pumpAndSettle();

      final lastContent = kIntroContents.last;

      expect(find.text(lastContent.title), findsOneWidget);
      expect(find.text(lastContent.body), findsOneWidget);
    });
  });
}
