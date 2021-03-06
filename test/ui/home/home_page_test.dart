import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_ui/bottom_navigation/bottom_navigation_cubit.dart';
import 'package:geldstroom/ui/home/home_page.dart';
import 'package:mockito/mockito.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../test_helper.dart';

class MockBottomNavigationCubit extends MockBloc<BottomNavigationState>
    implements BottomNavigationCubit {}

class MockOneSignal extends Mock implements OneSignal {}

void main() {
  BottomNavigationCubit bottomNavigationCubit;
  OneSignal oneSignal;
  Widget subject;
  const children = <Widget>[
    Scaffold(key: Key('page1')),
    Scaffold(key: Key('page2')),
  ];

  setUp(() {
    bottomNavigationCubit = MockBottomNavigationCubit();
    oneSignal = MockOneSignal();
    when(bottomNavigationCubit.state)
        .thenReturn(BottomNavigationState.initial());
    subject = buildTestableWidget(
      MultiBlocProvider(
        providers: [BlocProvider.value(value: bottomNavigationCubit)],
        child: HomePage(
          children: children,
          oneSignal: oneSignal,
        ),
      ),
    );
  });

  group('HomePage', () {
    group('renders', () {
      testWidgets('correctly', (tester) async {
        await tester.pumpWidget(subject);
        expect(find.byKey(Key('page1')), findsOneWidget);
        expect(find.byKey(Key('page2')), findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets('change bottom tabs', (tester) async {
        await tester.pumpWidget(subject);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(HomePage.settingIconKey));
        verify(bottomNavigationCubit.changeSelectedIndex(2)).called(1);
        await tester.tap(find.byKey(HomePage.homeIconKey));
        verify(bottomNavigationCubit.changeSelectedIndex(0)).called(1);
      });

      testWidgets('set onesignal subscription on init state', (tester) async {
        await tester.pumpWidget(subject);
        verify(oneSignal.setSubscription(true)).called(1);
      });
    });
  });
}
