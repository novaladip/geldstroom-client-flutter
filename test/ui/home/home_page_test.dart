import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/ui/home/home_page.dart';
import 'package:geldstroom/ui/home/widget/overview_balance.dart';
import 'package:geldstroom/ui/home/widget/overview_range_form.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

class MockOverviewBalanceCubit extends MockBloc<OverviewBalanceState>
    implements OverviewBalanceCubit {}

void main() {
  group('HomePage', () {
    Widget subject;
    OverviewRangeCubit overviewRangeCubit;
    OverviewBalanceCubit overviewBalanceCubit;

    setUp(() {
      overviewRangeCubit = MockOverviewRangeCubit();
      overviewBalanceCubit = MockOverviewBalanceCubit();
      subject = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: overviewRangeCubit),
          BlocProvider.value(value: overviewBalanceCubit),
        ],
        child: buildTestableBlocWidget(
          initialRoutes: HomePage.routeName,
          routes: {
            HomePage.routeName: (_) => HomePage(),
          },
        ),
      );
    });

    tearDown(() {
      overviewRangeCubit.close();
    });

    testWidgets('renders correctly', (tester) async {
      when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
      when(overviewBalanceCubit.state)
          .thenReturn(OverviewBalanceState.initial());
      await tester.pumpWidget(subject);

      expect(find.text(HomePage.appBarTitle), findsOneWidget);
      expect(find.byType(OverviewBalance), findsOneWidget);
      expect(
        find.byKey(HomePage.overviewRangeIconKey).hitTestable(),
        findsOneWidget,
      );
    });

    testWidgets(
        'should able to show OverviewRangeForm by tapping overview range icon',
        (tester) async {
      when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
      when(overviewBalanceCubit.state)
          .thenReturn(OverviewBalanceState.initial());
      await tester.pumpWidget(subject);

      final icon = find.byKey(HomePage.overviewRangeIconKey).hitTestable();
      await tester.tap(icon);
      await tester.pumpAndSettle();
      expect(find.byType(OverviewRangeForm), findsOneWidget);
    });
  });
}
