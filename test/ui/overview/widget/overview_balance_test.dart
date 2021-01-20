import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/ui/overview/widget/overview_balance.dart';
import 'package:mockito/mockito.dart';

import '../../../test_helper.dart';

class MockOverviewBalanceCubit extends MockBloc<OverviewBalanceState>
    implements OverviewBalanceCubit {}

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

void main() {
  group('OverviewBalance', () {
    OverviewBalanceCubit overviewBalanceCubit;
    OverviewRangeCubit overviewRangeCubit;
    Widget subject;

    setUp(() {
      overviewBalanceCubit = MockOverviewBalanceCubit();
      overviewRangeCubit = MockOverviewRangeCubit();
      subject = buildTestableWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: overviewBalanceCubit),
            BlocProvider.value(value: overviewRangeCubit),
          ],
          child: OverviewBalance(),
        ),
      );
    });

    tearDown(() {
      overviewBalanceCubit.close();
      overviewRangeCubit.close();
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.monthly());
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());

        await tester.pumpWidget(subject);

        final titlePrefix = overviewRangeCubit.state.when(
          monthly: () => 'month',
          weekly: () => 'week',
        );

        expect(
          find.text('${OverviewBalance.title} $titlePrefix'),
          findsOneWidget,
        );
        expect(find.text('Income'), findsOneWidget);
        expect(find.text('Expense'), findsOneWidget);
        expect(find.text('IDR0'), findsNWidgets(2));
      });
    });

    group('calls', () {
      testWidgets('fetch with OverviewViewState.weekly on initState',
          (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());

        await tester.pumpWidget(subject);

        verify(overviewBalanceCubit.fetch()).called(1);
      });

      testWidgets('fetch with OverviewViewState.monthly on initState',
          (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.monthly());
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());

        await tester.pumpWidget(subject);

        verify(overviewBalanceCubit.fetch()).called(1);
      });

      testWidgets(
          'should not fetch when OverviewBalanceState.status '
          'is loaded on init state', (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.monthly());
        when(overviewBalanceCubit.state).thenReturn(OverviewBalanceState(
          data: TransactionTotal(expense: 0, income: 0),
          status: Status.loaded(),
        ));

        await tester.pumpWidget(subject);

        verifyNever(overviewBalanceCubit.fetch());
      });
    });
  });
}
