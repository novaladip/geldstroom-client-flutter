import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

class MockTransactionService extends Mock implements ITransactionService {}

void main() {
  group('OverviewBalanceCubit', () {
    final state = OverviewBalanceState.initial();
    final transactionTotal = TransactionTotal(income: 20000, expense: 10000);

    OverviewBalanceCubit overviewBalanceCubit;
    ITransactionService transactionService;

    setUp(() {
      transactionService = MockTransactionService();
      overviewBalanceCubit = OverviewBalanceCubit(transactionService);
    });

    tearDown(() {
      overviewBalanceCubit.close();
    });

    test('initial state is correct', () {
      expect(overviewBalanceCubit.state, OverviewBalanceState.initial());
    });

    blocTest<OverviewBalanceCubit, OverviewBalanceState>(
      'emits correct state on clear',
      build: () => overviewBalanceCubit,
      act: (cubit) => cubit.clear(),
      expect: [OverviewBalanceState.initial()],
    );

    group('fetch', () {
      blocTest<OverviewBalanceCubit, OverviewBalanceState>(
        'weekly emits correct state when successful',
        build: () {
          when(transactionService.getBalance(any))
              .thenAnswer((_) async => Right(transactionTotal));
          return overviewBalanceCubit;
        },
        act: (cubit) => cubit.fetch(OverviewRangeState.weekly()),
        expect: [
          state.copyWith(status: Status.loading()),
          state.copyWith(status: Status.loaded(), data: transactionTotal),
        ],
      );

      blocTest<OverviewBalanceCubit, OverviewBalanceState>(
        'monthly emits correct state when successful',
        build: () {
          when(transactionService.getBalance(any))
              .thenAnswer((_) async => Right(transactionTotal));
          return overviewBalanceCubit;
        },
        act: (cubit) => cubit.fetch(OverviewRangeState.monthly()),
        expect: [
          state.copyWith(status: Status.loading()),
          state.copyWith(status: Status.loaded(), data: transactionTotal),
        ],
      );

      blocTest<OverviewBalanceCubit, OverviewBalanceState>(
        'emits correct state when failure',
        build: () {
          when(transactionService.getBalance(any))
              .thenAnswer((_) async => Left(ServerError.networkError()));
          return overviewBalanceCubit;
        },
        act: (cubit) => cubit.fetch(OverviewRangeState.weekly()),
        expect: [
          state.copyWith(status: Status.loading()),
          state.copyWith(
            status: Status.error(error: ServerError.networkError()),
          )
        ],
      );
    });
  });
}
