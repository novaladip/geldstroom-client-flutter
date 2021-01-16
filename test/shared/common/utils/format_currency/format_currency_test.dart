import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/common/utils/utils.dart';

import '../../../../test_helper.dart';

void main() {
  group('FormatCurrency', () {
    test('toIDR', () {
      final number = 10000;
      expect(FormatCurrency.toIDR(number), 'IDR10.000');
    });
  });

  group('AmountFormatter', () {
    testWidgets('shoud', (tester) async {
      final key = UniqueKey();
      final amountFormatter = AmountFormatter();
      final subject = buildTestableWidget(
        TextFormField(
          key: key,
          inputFormatters: [amountFormatter],
        ),
      );
      await tester.pumpWidget(subject);
      await tester.enterText(find.byKey(key), 's3x2000');
      await tester.enterText(find.byKey(key), '32000');
      await tester.pumpAndSettle();
      expect(find.text('32.000'), findsOneWidget);
    });
  });
}
