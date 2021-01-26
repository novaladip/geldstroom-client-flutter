import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/widget/widget.dart';

import '../../../test_helper.dart';

void main() {
  final message = 'Ops something went wrong';
  group('ErrorMessage', () {
    Widget subject;

    setUp(() {
      subject = buildTestableWidget(
        ErrorMessage(message: message),
      );
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        await tester.pumpWidget(subject);
        expect(find.byType(SvgPicture), findsOneWidget);
        expect(find.text(message), findsOneWidget);
      });
    });
  });

  group('ErrorMessageRetry', () {
    Widget subject;
    var retry = false;
    void onRetry() => retry = true;

    setUp(() {
      subject = buildTestableWidget(
        ErrorMessageRetry(
          message: message,
          onRetry: onRetry,
        ),
      );
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        await tester.pumpWidget(subject);
        expect(find.text(message), findsOneWidget);
        expect(find.text(ErrorMessageRetry.retryText), findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets('onRetry', (tester) async {
        await tester.pumpWidget(subject);
        await tester.tap(find.text(ErrorMessageRetry.retryText).hitTestable());
        expect(retry, true);
      });
    });
  });
}
