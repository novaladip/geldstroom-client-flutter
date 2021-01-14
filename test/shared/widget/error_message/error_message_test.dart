import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/widget/widget.dart';

import '../../../test_helper.dart';

void main() {
  group('ErrorMessage', () {
    Widget subject;
    final message = 'Ops something went wrong';

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
}
