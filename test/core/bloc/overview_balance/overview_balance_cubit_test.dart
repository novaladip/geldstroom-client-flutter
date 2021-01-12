import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/hydrated_bloc.dart';

class MockTransactionService extends Mock implements ITransactionService {}

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  initHydratedBloc();
  group('OverviewBalanceCubit', () {
    final state = OverviewBalanceState.initial();
    final transactionTotal = TransactionTotal(income: 20000, expense: 10000);

    OverviewBalanceCubit overviewBalanceCubit;
    OverviewRangeCubit overviewRangeCubit;
    AuthCubit authCubit;
    ITransactionService transactionService;

    setUp(() {
      transactionService = MockTransactionService();
      authCubit = MockAuthCubit();
      overviewRangeCubit = MockOverviewRangeCubit();
      overviewBalanceCubit = OverviewBalanceCubit(
        transactionService,
        overviewRangeCubit,
        authCubit,
      );
    });

    tearDown(() {
      overviewBalanceCubit.close();
      overviewRangeCubit.close();
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
          when(overviewRangeCubit.state).thenReturn(
            OverviewRangeState.weekly(),
          );
          when(transactionService.getBalance(any))
              .thenAnswer((_) async => Right(transactionTotal));
          return overviewBalanceCubit;
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          state.copyWith(status: Status.loading()),
          state.copyWith(status: Status.loaded(), data: transactionTotal),
        ],
      );

      blocTest<OverviewBalanceCubit, OverviewBalanceState>(
        'monthly emits correct state when successful',
        build: () {
          when(overviewRangeCubit.state).thenReturn(
            OverviewRangeState.monthly(),
          );
          when(transactionService.getBalance(any))
              .thenAnswer((_) async => Right(transactionTotal));
          return overviewBalanceCubit;
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          state.copyWith(status: Status.loading()),
          state.copyWith(status: Status.loaded(), data: transactionTotal),
        ],
      );

      blocTest<OverviewBalanceCubit, OverviewBalanceState>(
        'emits correct state when failure',
        build: () {
          when(overviewRangeCubit.state).thenReturn(
            OverviewRangeState.weekly(),
          );
          when(transactionService.getBalance(any))
              .thenAnswer((_) async => Left(ServerError.networkError()));
          return overviewBalanceCubit;
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          state.copyWith(status: Status.loading()),
          state.copyWith(
            status: Status.error(
              error: ServerError.networkError(),
            ),
          )
        ],
      );

      group('listen OverviewRangeState', () {
        blocTest<OverviewBalanceCubit, OverviewBalanceState>(
          'call fetch when OverviewRangeState is changed',
          build: () {
            when(transactionService.getBalance(any)).thenAnswer(
              (_) async => Right(transactionTotal),
            );
            whenListen(
              overviewRangeCubit,
              Stream.value(OverviewRangeState.weekly()),
            );
            return OverviewBalanceCubit(
              transactionService,
              overviewRangeCubit,
              authCubit,
            );
          },
          expect: [
            state.copyWith(status: Status.loading()),
            state.copyWith(status: Status.loaded(), data: transactionTotal),
          ],
        );
      });

      group('listen AuthState', () {
        blocTest<OverviewBalanceCubit, OverviewBalanceState>(
          'call clear when the new state is unauthenticated',
          build: () {
            whenListen(
              authCubit,
              Stream.value(AuthState.unauthenticated()),
            );
            return OverviewBalanceCubit(
              transactionService,
              overviewRangeCubit,
              authCubit,
            );
          },
          expect: [OverviewBalanceState.initial()],
        );

        blocTest<OverviewBalanceCubit, OverviewBalanceState>(
          'do nothing if the new state is not unauthenticated',
          build: () {
            whenListen(
              authCubit,
              Stream.value(AuthState.authenticated()),
            );
            return OverviewBalanceCubit(
              transactionService,
              overviewRangeCubit,
              authCubit,
            );
          },
          expect: [],
        );
      });
    });
  });
}
