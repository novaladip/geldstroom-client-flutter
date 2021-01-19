import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/transaction_create/transaction_create_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../network/service/transaction/json.dart';

class MockITransactionService extends Mock implements ITransactionService {}

void main() {
  group('TransactionCreateCubit', () {
    ITransactionService service;
    TransactionCreateCubit subject;
    final dto = TransactionCreateDto(
      amount: 50000,
      categoryId: '123-321',
      description: 'beli gado-gado',
      type: 'EXPENSE',
    );

    setUp(() {
      service = MockITransactionService();
      subject = TransactionCreateCubit(service);
    });

    tearDown(() {
      subject.clear();
    });

    test('initial state', () {
      expect(subject.state, FormStatusData<Transaction>.idle());
    });

    blocTest<TransactionCreateCubit, FormStatusData<Transaction>>(
      'clear',
      build: () => subject,
      act: (cubit) => cubit.clear(),
      expect: [FormStatusData<Transaction>.idle()],
    );

    group('submit', () {
      final transaction = Transaction.fromJson(getTransactionJson[0]);

      blocTest<TransactionCreateCubit, FormStatusData<Transaction>>(
        'when successful',
        build: () {
          when(service.create(dto)).thenAnswer(
            (_) async => Right(transaction),
          );
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormStatusData<Transaction>.loading(),
          FormStatusData<Transaction>.success(data: transaction),
        ],
        verify: (_) {
          verify(service.create(dto)).called(1);
        },
      );

      blocTest<TransactionCreateCubit, FormStatusData<Transaction>>(
        'when failure',
        build: () {
          when(service.create(dto)).thenAnswer(
            (_) async => Left(ServerError.networkError()),
          );
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormStatusData<Transaction>.loading(),
          FormStatusData<Transaction>.error(error: ServerError.networkError()),
        ],
        verify: (_) {
          verify(service.create(dto)).called(1);
        },
      );
    });
  });
}
