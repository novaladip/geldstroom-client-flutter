import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../overview_balance/overview_balance_cubit_test.dart';

class MockITransactionService extends Mock implements ITransactionService {}

void main() {
  group('TransactionDeleteCubit', () {
    ITransactionService service;

    setUp(() {
      service = MockTransactionService();
    });

    test('initial value', () {
      final subject = TransactionDeleteCubit(service);
      expect(subject.state, TransactionDeleteState.initial());
    });

    blocTest<TransactionDeleteCubit, TransactionDeleteState>(
      'clear',
      build: () => TransactionDeleteCubit(service),
      act: (cubit) => cubit.clear(),
      expect: [TransactionDeleteState.initial()],
    );

    group('delete', () {
      blocTest<TransactionDeleteCubit, TransactionDeleteState>(
        'when successful ',
        build: () {
          when(service.deleteOneById('1'))
              .thenAnswer((_) async => Right(None()));
          return TransactionDeleteCubit(service);
        },
        act: (cubit) => cubit.delete('1'),
        expect: [
          TransactionDeleteState(
            onDeleteProgressIds: ['1'],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: [],
          ),
          TransactionDeleteState(
            onDeleteProgressIds: [],
            onDeleteSuccessIds: ['1'],
            onDeleteFailureIds: [],
          ),
          TransactionDeleteState(
            onDeleteProgressIds: [],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: [],
          ),
        ],
      );
      blocTest<TransactionDeleteCubit, TransactionDeleteState>(
        'when failure',
        build: () {
          when(service.deleteOneById('1'))
              .thenAnswer((_) async => Left(ServerError.networkError()));
          return TransactionDeleteCubit(service);
        },
        act: (cubit) => cubit.delete('1'),
        expect: [
          TransactionDeleteState(
            onDeleteProgressIds: ['1'],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: [],
          ),
          TransactionDeleteState(
            onDeleteProgressIds: [],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: ['1'],
          ),
          TransactionDeleteState(
            onDeleteProgressIds: [],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: [],
          ),
        ],
      );
    });
  });
}
