import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/widget/date_form_field/date_form_field.dart';
import 'package:jiffy/jiffy.dart';

import '../../../test_helper.dart';

void main() {
  group('DateFormField', () {
    group('renders', () {
      testWidgets('correctly', (tester) async {
        var today = Jiffy().startOf(Units.MONTH);
        final lastDate = Jiffy().endOf(Units.MONTH);

        final subject = buildTestableWidget(
          Center(
            child: DateFormField(
              labelText: 'Select a date',
              currentValue: today,
              onChange: (value) => today = value,
              firstDate: today,
              lastDate: lastDate,
              errorText: 'Show me if im not null',
            ),
          ),
        );

        await tester.pumpWidget(subject);
        expect(find.text('Select a date'), findsOneWidget);
        expect(find.text(Jiffy(today).format('MM-dd-yyyy')), findsOneWidget);
        expect(find.text('Show me if im not null'), findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets('change value', (tester) async {
        final today = Jiffy().startOf(Units.MONTH);
        var currentValue = today;
        final lastDate = Jiffy().endOf(Units.MONTH);
        final key = Key('date_form_field');

        final subject = buildTestableWidget(
          Center(
            child: DateFormField(
              labelText: 'Select a date',
              currentValue: currentValue,
              onChange: (value) => currentValue = value,
              firstDate: currentValue,
              lastDate: lastDate,
              errorText: 'Show me if im not null',
              key: key,
            ),
          ),
        );

        await tester.pumpWidget(subject);
        expect(find.text(Jiffy(currentValue).format('MM-dd-yyyy')),
            findsOneWidget);
        await tester.tap(find.byKey(key).hitTestable());
        await tester.pumpAndSettle();
        await tester.tap(find.text('${currentValue.day + 1}').hitTestable());
        await tester.tap(find.text('OK').hitTestable());
        await tester.pumpAndSettle();
        expect(currentValue, today.add(Duration(days: 1)));
      });
    });
  });
}
