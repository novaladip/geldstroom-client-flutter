import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/ui/overview/widget/overview_balance.dart';
import 'package:mockito/mockito.dart';

import '../../../test_helper.dart';

class MockOverviewBalanceCubit extends MockBloc<OverviewBalanceState>
    implements OverviewBalanceCubit {}

void main() {
  group('OverviewBalance', () {
    OverviewBalanceCubit overviewBalanceCubit;
    Widget subject;

    setUp(() {
      overviewBalanceCubit = MockOverviewBalanceCubit();
      subject = buildTestableWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: overviewBalanceCubit),
          ],
          child: Scaffold(
            body: CustomScrollView(slivers: [
              OverviewBalance(),
            ]),
          ),
        ),
      );
    });

    tearDown(() {
      overviewBalanceCubit.close();
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        final state = OverviewBalanceState(
          data: TransactionTotal(
            income: 100000,
            expense: 50000,
          ),
          status: Status.loaded(),
        );
        when(overviewBalanceCubit.state).thenReturn(state);

        await tester.pumpWidget(subject);

        expect(find.text('Income'), findsOneWidget);
        expect(find.text('Expense'), findsOneWidget);
        expect(find.text('IDR100.000'), findsOneWidget); // income
        expect(find.text('IDR50.000'), findsOneWidget); // expense
      });
    });

    group('calls', () {
      testWidgets('overviewBalanceCubit.fetch() on initState', (tester) async {
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());

        await tester.pumpWidget(subject);

        verify(overviewBalanceCubit.fetch()).called(1);
      });

      testWidgets(
          'should not call overviewBalanceCubit.fetch() '
          'when OverviewBalanceState.status is loaded on init state',
          (tester) async {
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
