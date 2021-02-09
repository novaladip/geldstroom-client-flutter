// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc/overview_transaction/overview_transaction_bloc.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/tranasction_json.dart';

class MockTransactionService extends Mock implements TransactionService {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

class MockTransactionCreateCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionCreateCubit {}

class MockTransactionEditCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionEditCubit {}

class MockTransactionDeleteCubit extends MockBloc<DeleteState>
    implements TransactionDeleteCubit {}

void main() {
  group('OverviewTransactionBloc', () {
    TransactionService service;
    OverviewTransactionBloc overviewTransactionBloc;
    OverviewRangeCubit overviewRangeCubit;
    TransactionCreateCubit transactionCreateCubit;
    TransactionEditCubit transactionEditCubit;
    TransactionDeleteCubit transactionDeleteCubit;
    AuthCubit authCubit;

    final transactions = TransactionJson.listTransaction
        .map((json) => Transaction.fromJson(json))
        .toList();

    setUp(() {
      service = MockTransactionService();
      authCubit = MockAuthCubit();
      overviewRangeCubit = MockOverviewRangeCubit();
      transactionCreateCubit = MockTransactionCreateCubit();
      transactionEditCubit = MockTransactionEditCubit();
      transactionDeleteCubit = MockTransactionDeleteCubit();
      overviewTransactionBloc = OverviewTransactionBloc(
        service,
        authCubit,
        overviewRangeCubit,
        transactionCreateCubit,
        transactionEditCubit,
        transactionDeleteCubit,
      );
    });

    tearDown(() {
      authCubit.close();
      overviewRangeCubit.close();
      overviewTransactionBloc.close();
      transactionCreateCubit.close();
      transactionEditCubit.close();
      transactionDeleteCubit.close();
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
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
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
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
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
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
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
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
            );
          },
          verify: (_) {
            verify(service.getTransactions(any)).called(1);
          },
        );
      });

      group('listen for TransactionCreateState', () {
        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'should add OverviewTransactionEvent.add when state is success',
          seed: OverviewTransactionState(
            data: [],
            isReachEnd: true,
            status: FetchStatus.loadSuccess(),
          ),
          build: () {
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.monthly());
            whenListen(
              transactionCreateCubit,
              Stream.value(
                FormStatusDataSuccess<Transaction>(data: transactions[0]),
              ),
            );
            return OverviewTransactionBloc(
              service,
              authCubit,
              overviewRangeCubit,
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
            );
          },
          expect: [
            OverviewTransactionState(
              data: [transactions[0]],
              isReachEnd: true,
              status: FetchStatus.loadSuccess(),
            ),
          ],
        );
      });

      group('listen for TransactionEditState', () {
        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'should add OverviewTransactionEvent.update when state is success',
          seed: OverviewTransactionState(
            data: transactions,
            status: FetchStatus.loadSuccess(),
          ),
          build: () {
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.monthly());
            when(authCubit.state).thenReturn(AuthState.authenticated());
            whenListen(
              transactionEditCubit,
              Stream.value(
                FormStatusData<Transaction>.success(
                  data: Transaction(
                    id: transactions[0].id,
                    amount: 20000,
                    category: transactions[0].category,
                    description: '',
                    createdAt: transactions[0].createdAt,
                    updatedAt: transactions[0].updatedAt,
                    type: transactions[0].type,
                    userId: transactions[0].userId,
                  ),
                ),
              ),
            );
            return OverviewTransactionBloc(
              service,
              authCubit,
              overviewRangeCubit,
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
            );
          },
          expect: [
            OverviewTransactionState(
              data: [
                Transaction(
                  id: transactions[0].id,
                  amount: 20000,
                  category: transactions[0].category,
                  description: '',
                  createdAt: transactions[0].createdAt,
                  updatedAt: transactions[0].updatedAt,
                  type: transactions[0].type,
                  userId: transactions[0].userId,
                ),
                transactions[1],
              ],
              status: FetchStatus.loadSuccess(),
            ),
          ],
        );

        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'do nothing when state is not success',
          seed: OverviewTransactionState(
            data: transactions,
            status: FetchStatus.loadSuccess(),
          ),
          build: () {
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.monthly());
            when(authCubit.state).thenReturn(AuthState.authenticated());
            whenListen(
              transactionEditCubit,
              Stream.value(FormStatusData<Transaction>.loading()),
            );
            return OverviewTransactionBloc(
              service,
              authCubit,
              overviewRangeCubit,
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
            );
          },
          expect: [],
        );
      });

      group('listen for TransactionDeleteState', () {
        blocTest<OverviewTransactionBloc, OverviewTransactionState>(
          'add OverviewTransactionEvent.delete when onDeleteSuccessIds changed',
          build: () {
            whenListen(
              transactionDeleteCubit,
              Stream.value(
                DeleteState(
                  onDeleteFailureIds: [],
                  onDeleteProgressIds: [],
                  onDeleteSuccessIds: [transactions[0].id],
                ),
              ),
            );
            when(overviewRangeCubit.state)
                .thenReturn(OverviewRangeState.monthly());
            return OverviewTransactionBloc(
              service,
              authCubit,
              overviewRangeCubit,
              transactionCreateCubit,
              transactionEditCubit,
              transactionDeleteCubit,
            );
          },
          seed: OverviewTransactionState(
            data: transactions,
            isReachEnd: false,
            status: FetchStatus.loadSuccess(),
          ),
          expect: [
            OverviewTransactionState(
              data: transactions
                  .where((transaction) => transaction.id != transactions[0].id)
                  .toList(),
              isReachEnd: false,
              status: FetchStatus.loadSuccess(),
            ),
          ],
        );
      });
    });
  });
}
