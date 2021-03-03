import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/widget/widget.dart';

import '../../../helper_tests/finder.dart';
import '../../../test_helper.dart';

void main() {
  group('LinkText', () {
    testWidgets('correctly', (tester) async {
      final text = 'Hello world! https://google.com';
      final subject = buildTestableWidget(
        LinkText(
          text: text,
          onOpen: (value) {},
          textStyle: TextStyle(),
        ),
      );
      await tester.pumpWidget(subject);

      final textFinder = find
          .byWidgetPredicate((widget) => fromRichTextToPlainText(widget, text));
      expect(textFinder, findsOneWidget);
    });

    testWidgets('should able to tap text url', (tester) async {
      final log = <String>[];
      final text = 'https://google.com';
      final subject = buildTestableWidget(
        LinkText(
          text: text,
          onOpen: log.add,
          textStyle: TextStyle(),
        ),
      );
      await tester.pumpWidget(subject);

      final textFinder = find
          .byWidgetPredicate((widget) => fromRichTextToPlainText(widget, text));
      await tester.tap(textFinder.hitTestable());
      expect(log, [text]);
    });
  });
}
