import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

class MockITransactionService extends Mock implements ITransactionService {}

void main() {
  group('DeleteCubit', () {
    ITransactionService service;

    setUp(() {
      service = MockITransactionService();
    });

    test('initial value', () {
      final subject = TransactionDeleteCubit(service);
      expect(subject.state, DeleteState.initial());
    });

    blocTest<DeleteCubit, DeleteState>(
      'clear',
      build: () => DeleteCubit(service.deleteOneById),
      act: (cubit) => cubit.clear(),
      expect: [DeleteState.initial()],
    );

    group('delete', () {
      blocTest<DeleteCubit, DeleteState>(
        'when successful ',
        build: () {
          when(service.deleteOneById('1'))
              .thenAnswer((_) async => Right(None()));
          return DeleteCubit(service.deleteOneById);
        },
        act: (cubit) => cubit.delete('1'),
        expect: [
          DeleteState(
            onDeleteProgressIds: ['1'],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: [],
          ),
          DeleteState(
            onDeleteProgressIds: [],
            onDeleteSuccessIds: ['1'],
            onDeleteFailureIds: [],
          ),
          DeleteState(
            onDeleteProgressIds: [],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: [],
          ),
        ],
      );
      blocTest<DeleteCubit, DeleteState>(
        'when failure',
        build: () {
          when(service.deleteOneById('1'))
              .thenAnswer((_) async => Left(ServerError.networkError()));
          return DeleteCubit(service.deleteOneById);
        },
        act: (cubit) => cubit.delete('1'),
        expect: [
          DeleteState(
            onDeleteProgressIds: ['1'],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: [],
          ),
          DeleteState(
            onDeleteProgressIds: [],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: ['1'],
          ),
          DeleteState(
            onDeleteProgressIds: [],
            onDeleteSuccessIds: [],
            onDeleteFailureIds: [],
          ),
        ],
      );
    });
  });
}
