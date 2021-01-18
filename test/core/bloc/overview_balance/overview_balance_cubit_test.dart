import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/bloc/transaction_edit/transaction_edit_cubit.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/hydrated_bloc.dart';
import '../../network/service/transaction/json.dart';

class MockTransactionService extends Mock implements ITransactionService {}

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

class MockTransactionEditCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionEditCubit {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  initHydratedBloc();
  group('OverviewBalanceCubit', () {
    final state = OverviewBalanceState.initial();
    final transactionTotal = TransactionTotal(income: 20000, expense: 10000);

    OverviewBalanceCubit overviewBalanceCubit;
    OverviewRangeCubit overviewRangeCubit;
    TransactionEditCubit transactionEditCubit;
    AuthCubit authCubit;
    ITransactionService transactionService;

    setUp(() {
      transactionService = MockTransactionService();
      authCubit = MockAuthCubit();
      transactionEditCubit = MockTransactionEditCubit();
      overviewRangeCubit = MockOverviewRangeCubit();
      overviewBalanceCubit = OverviewBalanceCubit(
        transactionService,
        overviewRangeCubit,
        transactionEditCubit,
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
              transactionEditCubit,
              authCubit,
            );
          },
          expect: [
            state.copyWith(status: Status.loading()),
            state.copyWith(status: Status.loaded(), data: transactionTotal),
          ],
        );
      });

      group('listen TransactionEditState', () {
        blocTest<OverviewBalanceCubit, OverviewBalanceState>(
          'call fetch when state is success',
          build: () {
            when(transactionService.getBalance(any)).thenAnswer(
              (_) async => Right(transactionTotal),
            );
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.weekly());
            whenListen(
              transactionEditCubit,
              Stream.value(
                FormStatusData<Transaction>.success(
                  data: Transaction.fromJson(getTransactionJson[0]),
                ),
              ),
            );
            return OverviewBalanceCubit(
              transactionService,
              overviewRangeCubit,
              transactionEditCubit,
              authCubit,
            );
          },
          expect: [
            state.copyWith(status: Status.loading()),
            state.copyWith(status: Status.loaded(), data: transactionTotal),
          ],
          verify: (_) {
            verify(transactionService.getBalance(any)).called(1);
          },
        );

        blocTest<OverviewBalanceCubit, OverviewBalanceState>(
          'do nothing when state is not success',
          build: () {
            when(transactionService.getBalance(any)).thenAnswer(
              (_) async => Right(transactionTotal),
            );
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.weekly());
            whenListen(
              transactionEditCubit,
              Stream.value(FormStatusData<Transaction>.loading()),
            );
            return OverviewBalanceCubit(
              transactionService,
              overviewRangeCubit,
              transactionEditCubit,
              authCubit,
            );
          },
          expect: [],
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
              transactionEditCubit,
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
              transactionEditCubit,
              authCubit,
            );
          },
          expect: [],
        );
      });
    });
  });
}
