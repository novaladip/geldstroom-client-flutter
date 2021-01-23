import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/password_change/widgets/password_change_header.dart';

import '../../../test_helper.dart';

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainButton(
        title: 'Tap Me',
        onTap: () => Navigator.of(context).pushNamed('/2'),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasswordChangeHeader(),
    );
  }
}

void main() {
  group('PasswordChangeHeader', () {
    final routes = <String, WidgetBuilder>{
      '/1': (_) => Screen1(),
      '/2': (_) => Screen2(),
    };
    final subject = buildTestableWidget(
      MaterialApp(routes: routes, initialRoute: '/1'),
    );

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(subject);

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();
      expect(find.byType(Icon), findsOneWidget);
      await tester.tap(find.byType(Icon));
      await tester.pumpAndSettle();
      expect(find.byType(Screen2), findsNothing);
    });
  });
}
