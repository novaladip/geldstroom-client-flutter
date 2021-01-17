// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/transaction_edit/transaction_edit_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../network/service/transaction/json.dart';
import '../overview_balance/overview_balance_cubit_test.dart';

class MockITransactionService extends Mock implements ITransactionService {}

void main() {
  group('TransactionEditCubit', () {
    ITransactionService service;
    TransactionEditCubit subject;

    setUp(() {
      service = MockTransactionService();
      subject = TransactionEditCubit(service);
    });

    group('submit', () {
      final dto = TransactionEditDto(
        amount: 123,
        categoryId: '1',
        description: 'dada',
        id: '1',
        type: 'INCOME',
      );

      final successResult = Transaction.fromJson(getTransactionJson[0]);

      blocTest<TransactionEditCubit, FormStatusData<Transaction>>(
        'emits status with [loading, success(data: Transaction)] when successful',
        build: () {
          when(service.edit(dto)).thenAnswer((_) async => Right(successResult));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormStatusData.loading(),
          FormStatusData.success(data: successResult),
        ],
      );

      blocTest<TransactionEditCubit, FormStatusData<Transaction>>(
        'emits status with [loading, error(error: ServerError)] when failure',
        build: () {
          when(service.edit(dto))
              .thenAnswer((_) async => Left(ServerError.unknownError()));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormStatusData.loading(),
          FormStatusData.error(error: ServerError.unknownError()),
        ],
      );
    });

    blocTest<TransactionEditCubit, FormStatusData<Transaction>>(
      'emits status with [idle]',
      build: () => subject,
      act: (cubit) => cubit.clear(),
      expect: [FormStatusData.idle()],
    );
  });
}
