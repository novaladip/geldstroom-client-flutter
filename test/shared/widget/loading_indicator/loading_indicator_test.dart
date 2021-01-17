import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/widget/loading_indicator/loading_indicator.dart';

import '../../../test_helper.dart';

void main() {
  group('LoadingIndicator', () {
    group('renders', () {
      testWidgets('correctly', (tester) async {
        final subject = buildTestableWidget(LoadingIndicator());
        await tester.pumpWidget(subject);
        expect(find.byType(SpinKitChasingDots), findsOneWidget);
      });
    });
  });
}
