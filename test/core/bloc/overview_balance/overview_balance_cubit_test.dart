// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
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

class MockTransactionCreateCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionCreateCubit {}

class MockTransactionEditCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionEditCubit {}

class MockTransactionDeleteCubit extends MockBloc<TransactionDeleteState>
    implements TransactionDeleteCubit {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  initHydratedBloc();
  group('OverviewBalanceCubit', () {
    final state = OverviewBalanceState.initial();
    final transactionTotal = TransactionTotal(income: 20000, expense: 10000);

    OverviewBalanceCubit overviewBalanceCubit;
    OverviewRangeCubit overviewRangeCubit;
    TransactionCreateCubit transactionCreateCubit;
    TransactionEditCubit transactionEditCubit;
    TransactionDeleteCubit transactionDeleteCubit;
    AuthCubit authCubit;
    ITransactionService transactionService;

    setUp(() {
      transactionService = MockTransactionService();
      authCubit = MockAuthCubit();
      transactionCreateCubit = MockTransactionCreateCubit();
      transactionEditCubit = MockTransactionEditCubit();
      transactionDeleteCubit = MockTransactionDeleteCubit();
      overviewRangeCubit = MockOverviewRangeCubit();

      overviewBalanceCubit = OverviewBalanceCubit(
        transactionService,
        overviewRangeCubit,
        transactionCreateCubit,
        transactionEditCubit,
        transactionDeleteCubit,
        authCubit,
      );
    });

    tearDown(() {
      overviewBalanceCubit.close();
      overviewRangeCubit.close();
      transactionCreateCubit.close();
      transactionEditCubit.close();
      transactionDeleteCubit.close();
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
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
              authCubit,
            );
          },
          expect: [
            state.copyWith(status: Status.loading()),
            state.copyWith(status: Status.loaded(), data: transactionTotal),
          ],
        );
      });

      group('listen TransactionCreateState', () {
        blocTest<OverviewBalanceCubit, OverviewBalanceState>(
          'call fetch when state is success',
          build: () {
            when(transactionService.getBalance(any)).thenAnswer(
              (_) async => Right(transactionTotal),
            );
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.weekly());
            whenListen(
              transactionCreateCubit,
              Stream.value(
                FormStatusData<Transaction>.success(
                  data: Transaction.fromJson(getTransactionJson[0]),
                ),
              ),
            );
            return OverviewBalanceCubit(
              transactionService,
              overviewRangeCubit,
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
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
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
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
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
              authCubit,
            );
          },
          expect: [],
        );
      });

      group('listen TransactionDeleteState', () {
        blocTest<OverviewBalanceCubit, OverviewBalanceState>(
          'call fetch when transactionDeleteState is onDeleteSuccessIds is changed',
          build: () {
            when(transactionService.getBalance(any)).thenAnswer(
              (_) async => Right(transactionTotal),
            );
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.weekly());
            whenListen(
              transactionDeleteCubit,
              Stream.value(
                TransactionDeleteState(
                  onDeleteFailureIds: [],
                  onDeleteProgressIds: [],
                  onDeleteSuccessIds: ['1'],
                ),
              ),
            );
            return OverviewBalanceCubit(
              transactionService,
              overviewRangeCubit,
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
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
          'do nothing when transactionDeleteState onDeleteSuccessIds is not changed',
          build: () {
            when(transactionService.getBalance(any)).thenAnswer(
              (_) async => Right(transactionTotal),
            );
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.weekly());
            whenListen(
              transactionDeleteCubit,
              Stream.value(
                TransactionDeleteState(
                  onDeleteFailureIds: [],
                  onDeleteProgressIds: ['1'],
                  onDeleteSuccessIds: [],
                ),
              ),
            );
            return OverviewBalanceCubit(
              transactionService,
              overviewRangeCubit,
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
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
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
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
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
              authCubit,
            );
          },
          expect: [],
        );
      });
    });
  });
}
