import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/widgets/shared/quotes.dart';

import 'test-wrapper.dart';

void main() {
  final quote = 'Lorem ipsum dolor sir amet';
  testWidgets(
    'Render correct quote',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        TestWrapper(
          child: Quotes(
            quote: quote,
          ),
        ),
      );

      final quoteFinder = find.text(quote);
      final notFoundFinder = find.text('Cant found');
      expect(quoteFinder, findsOneWidget);
      expect(notFoundFinder, findsNothing);
    },
  );
}
