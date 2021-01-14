// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc/overview_transaction/overview_transaction_bloc.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/tranasction_json.dart';

class MockTransactionService extends Mock implements TransactionService {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

void main() {
  group('OverviewTransactionBloc', () {
    TransactionService service;
    OverviewTransactionBloc overviewTransactionBloc;
    OverviewRangeCubit overviewRangeCubit;
    AuthCubit authCubit;

    final transactions = TransactionJson.listTransaction
        .map((json) => Transaction.fromJson(json))
        .toList();

    setUp(() {
      service = MockTransactionService();
      authCubit = MockAuthCubit();
      overviewRangeCubit = MockOverviewRangeCubit();
      overviewTransactionBloc = OverviewTransactionBloc(
        service,
        authCubit,
        overviewRangeCubit,
      );
    });

    tearDown(() {
      overviewTransactionBloc.close();
      overviewRangeCubit.close();
      authCubit.close();
    });

    test('correct initial state', () {
      when(authCubit.state).thenReturn(AuthState.authenticated());
      when(overviewRangeCubit.state).thenReturn(
        OverviewRangeState.weekly(),
      );
      expect(
        overviewTransactionBloc.state,
        OverviewTransactionState(),
      );
    });

    group('event', () {
      group('OverviewTransactionEvent.fetch', () {
        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'emits [State(status: FetchStatusLoadInProgress, data: []), '
          'State(status: FetchStatusLoadSuccess, data: [Transaction], isReachEnd: true)] '
          'when successful',
          build: () {
            when(overviewRangeCubit.state).thenReturn(
              OverviewRangeState.weekly(),
            );
            when(authCubit.state).thenReturn(AuthState.authenticated());
            when(service.getTransactions(any))
                .thenAnswer((_) async => Right(transactions));
            return overviewTransactionBloc;
          },
          act: (bloc) => bloc.add(OverviewTransactionEvent.fetch()),
          expect: [
            OverviewTransactionState(status: FetchStatus.loadInProgress()),
            OverviewTransactionState(
              status: FetchStatus.loadSuccess(),
              data: transactions,
              isReachEnd: true,
            ),
          ],
        );

        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'emits with fetch status [loadInProgress, loadFailure] when failure',
          build: () {
            when(authCubit.state).thenReturn(AuthState.authenticated());
            when(overviewRangeCubit.state).thenReturn(
              OverviewRangeState.monthly(),
            );
            when(service.getTransactions(any)).thenAnswer(
              (_) async => Left(ServerError.networkError()),
            );
            return overviewTransactionBloc;
          },
          act: (bloc) => bloc.add(OverviewTransactionEvent.fetch()),
          expect: [
            OverviewTransactionState(status: FetchStatus.loadInProgress()),
            OverviewTransactionState(
              status: FetchStatus.loadFailure(
                error: ServerError.networkError(),
              ),
            ),
          ],
        );
      });

      group('OverviewTransactionEvent.fetchMore', () {
        final data = List<Transaction>.generate(15, (_) => transactions[0]);

        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'when successful state.data.length is should be 30',
          build: () {
            when(authCubit.state).thenReturn(AuthState.authenticated());
            when(overviewRangeCubit.state).thenReturn(
              OverviewRangeState.initial(),
            );
            when(service.getTransactions(any)).thenAnswer(
              (_) async => Right(data),
            );

            return overviewTransactionBloc;
          },
          act: (bloc) => bloc..add(OverviewTransactionEvent.fetchMore()),
          wait: Duration(milliseconds: 500),
          seed: OverviewTransactionState(
            data: data,
            status: FetchStatus.loadSuccess(),
          ),
          verify: (bloc) {
            expect(bloc.state.data.length, 30);
            expect(bloc.state.status, isA<FetchStatusLoadSuccess>());
            verify(service.getTransactions(any)).called(1);
          },
        );

        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'emits status [fetchInProgress, fetchMoreFailure, loadSuccess] when failure',
          build: () {
            when(authCubit.state).thenReturn(AuthState.authenticated());
            when(overviewRangeCubit.state).thenReturn(
              OverviewRangeState.initial(),
            );
            when(service.getTransactions(any)).thenAnswer(
              (_) async => Left(ServerError.networkError()),
            );

            return overviewTransactionBloc;
          },
          act: (bloc) => bloc..add(OverviewTransactionEvent.fetchMore()),
          wait: Duration(milliseconds: 500),
          seed: OverviewTransactionState(
            data: data,
            status: FetchStatus.loadSuccess(),
          ),
          expect: [
            OverviewTransactionState(
              data: data,
              status: FetchStatus.fetchMoreInProgress(),
            ),
            OverviewTransactionState(
              data: data,
              status: FetchStatus.fetchMoreFailure(
                error: ServerError.networkError(),
              ),
            ),
            OverviewTransactionState(
              data: data,
              status: FetchStatus.loadSuccess(),
            ),
          ],
        );
        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'emits nothing when isReachEnd is true',
          build: () {
            when(authCubit.state).thenReturn(AuthState.authenticated());
            when(overviewRangeCubit.state).thenReturn(
              OverviewRangeState.initial(),
            );
            when(service.getTransactions(any)).thenAnswer(
              (_) async => Right(data),
            );

            return overviewTransactionBloc;
          },
          act: (bloc) => bloc..add(OverviewTransactionEvent.fetchMore()),
          seed: OverviewTransactionState(
            isReachEnd: true,
            status: FetchStatus.loadSuccess(),
          ),
          expect: [],
          verify: (_) {
            verifyNever(service.getTransactions(any));
          },
        );
      });

      group('OverviewTransactionEvent.add', () {
        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'should add new Transaction to current state.data',
          build: () {
            when(overviewRangeCubit.state).thenReturn(
              OverviewRangeState.weekly(),
            );
            when(authCubit.state).thenReturn(AuthState.authenticated());
            when(service.getTransactions(any))
                .thenAnswer((_) async => Right(transactions));
            return overviewTransactionBloc;
          },
          act: (bloc) => bloc
            ..add(OverviewTransactionEvent.fetch())
            ..add(OverviewTransactionEvent.add(transactions[1])),
          expect: [
            OverviewTransactionState(status: FetchStatus.loadInProgress()),
            OverviewTransactionState(
              status: FetchStatus.loadSuccess(),
              data: transactions,
              isReachEnd: true,
            ),
            OverviewTransactionState(
              status: FetchStatus.loadSuccess(),
              data: [transactions[1], ...transactions],
              isReachEnd: true,
            ),
          ],
        );
      });

      group('OverviewTransactionEvent.delete', () {
        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'should remove transaction by given id from state.data',
          build: () {
            when(overviewRangeCubit.state).thenReturn(
              OverviewRangeState.weekly(),
            );
            when(authCubit.state).thenReturn(AuthState.authenticated());
            when(service.getTransactions(any))
                .thenAnswer((_) async => Right(transactions));
            return overviewTransactionBloc;
          },
          act: (bloc) => bloc
            ..add(OverviewTransactionEvent.fetch())
            ..add(OverviewTransactionEvent.delete(transactions[1].id)),
          expect: [
            OverviewTransactionState(status: FetchStatus.loadInProgress()),
            OverviewTransactionState(
              status: FetchStatus.loadSuccess(),
              data: transactions,
              isReachEnd: true,
            ),
            OverviewTransactionState(
              status: FetchStatus.loadSuccess(),
              data: transactions
                  .where((transaction) => transaction.id != transactions[1].id)
                  .toList(),
              isReachEnd: true,
            ),
          ],
        );
      });
    });

    group('listen', () {
      group('listen for AuthState', () {
        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'when AuthState is changed to unauthenticated '
          'should reset state to initial',
          build: () {
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.monthly());

            whenListen(
              authCubit,
              Stream.value(AuthState.unauthenticated()),
            );
            return OverviewTransactionBloc(
              service,
              authCubit,
              overviewRangeCubit,
            );
          },
          expect: [OverviewTransactionState()],
        );

        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'add nothing when AuthState is changed to other than unauthenticated ',
          build: () {
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.monthly());

            whenListen(
              authCubit,
              Stream.value(AuthState.authenticated()),
            );
            return OverviewTransactionBloc(
              service,
              authCubit,
              overviewRangeCubit,
            );
          },
          expect: [],
        );
      });
      group('listen for OverviewRangeState', () {
        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'should call TransactionService.getTransaction '
          'when OverviewRangeState is changed to weekly',
          build: () {
            whenListen(
              overviewRangeCubit,
              Stream.value(OverviewRangeState.weekly()),
            );
            when(authCubit.state).thenReturn(AuthState.authenticated());
            return OverviewTransactionBloc(
              service,
              authCubit,
              overviewRangeCubit,
            );
          },
          verify: (_) {
            verify(service.getTransactions(any)).called(1);
          },
        );

        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'should call TransactionService.getTransaction '
          'when OverviewRangeState is changed to monthly',
          build: () {
            whenListen(
              overviewRangeCubit,
              Stream.value(OverviewRangeState.monthly()),
            );
            when(authCubit.state).thenReturn(AuthState.authenticated());
            return OverviewTransactionBloc(
              service,
              authCubit,
              overviewRangeCubit,
            );
          },
          verify: (_) {
            verify(service.getTransactions(any)).called(1);
          },
        );
      });
    });
  });
}
