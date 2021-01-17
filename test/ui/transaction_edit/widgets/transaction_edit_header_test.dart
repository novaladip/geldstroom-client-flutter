import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/ui/transaction_edit/widgets/transaction_edit_header.dart';

import '../../../test_helper.dart';

void main() {
  group('TransactionEditHeader', () {
    group('renders', () {
      testWidgets('correctly', (tester) async {
        final subject = buildTestableWidget(TransactionEditHeader());
        await tester.pumpWidget(subject);
        expect(find.text('Edit Transaction'), findsOneWidget);
      });
    });
  });
}
