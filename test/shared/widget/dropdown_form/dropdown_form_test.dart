import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/widget/dropdown_form/dropdown_form.dart';

import '../../../test_helper.dart';

void main() {
  group('DropdownForm', () {
    final labelText = 'ABC';
    final options = ['A', 'B', 'C'];
    var currentValue = options[0];

    void onChange(String value) {
      currentValue = value;
    }

    testWidgets('render correctly', (tester) async {
      final subject = buildTestableWidget(
        DropdownForm<String>(
          labelText: labelText,
          currentValue: currentValue,
          options: options,
          onChanged: onChange,
          renderItem: (value) => Text(value),
        ),
      );
      await tester.pumpWidget(subject);

      expect(find.text(currentValue), findsOneWidget);
      expect(find.text(labelText), findsOneWidget);
    });

    testWidgets('change correctly', (tester) async {
      final key = Key('dropdown');
      final subject = buildTestableWidget(
        DropdownForm<String>(
          key: key,
          labelText: labelText,
          currentValue: currentValue,
          options: options,
          onChanged: onChange,
          renderItem: (value) => Text(
            value,
            key: Key(value),
          ),
        ),
      );
      await tester.pumpWidget(subject);

      await tester.tap(find.byKey(key));
      await tester.pumpAndSettle();

      for (var option in options) {
        if (option == currentValue) {
          expect(find.byKey(Key(option)), findsNWidgets(2));
          return;
        }
        expect(find.byKey(Key(option)), findsOneWidget);
      }
      await tester.tap(find.text(options[1]));
      expect(currentValue, options[1]);
    });
  });
}
