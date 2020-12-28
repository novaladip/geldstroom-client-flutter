import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/widget/main_button/main_button.dart';

import '../../../test_helper.dart';

void main() {
  group('MainButton', () {
    testWidgets('given loading false should only render title', (tester) async {
      var isTapped = false;
      final subject = buildTestableWidget(
        MainButton(
          title: 'Tap Me',
          onTap: () => isTapped = true,
        ),
      );

      await tester.pumpWidget(subject);

      final titleFinder = find.text('Tap Me');
      final loadingIndicatorFinder = find.byKey(loadingIndicatorKey);

      expect(isTapped, false);
      expect(titleFinder, findsOneWidget);
      expect(loadingIndicatorFinder, findsNothing);

      await tester.tap(titleFinder);
      expect(isTapped, true);
    });

    testWidgets('given loading true should only render loading indicator',
        (tester) async {
      final subject = await buildTestableWidget(MainButton(
        title: 'Tap Me',
        onTap: () {},
        loading: true,
      ));

      await tester.pumpWidget(subject);

      final titleFinder = find.text('Tap Me');
      final loadingIndicatorFinder = find.byKey(loadingIndicatorKey);

      expect(titleFinder, findsNothing);
      expect(loadingIndicatorFinder, findsOneWidget);
    });

    testWidgets('given disable true, should ignore onTap', (tester) async {
      var isTapped = false;
      final subject = await buildTestableWidget(
        MainButton(
          title: 'Tap Me',
          onTap: () => isTapped = true,
          disabled: true,
        ),
      );

      await tester.pumpWidget(subject);

      final titleFinder = find.text('Tap Me');
      expect(isTapped, false);
      await tester.tap(titleFinder);
      expect(isTapped, false);
    });
  });
}
