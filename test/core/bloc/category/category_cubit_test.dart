// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

class MockCategoryService extends Mock implements ICategoryService {}

void main() {
  group('CategoryCubit', () {
    final categories = <TransactionCategory>[
      TransactionCategory(
        id: '321-321',
        name: 'Food',
        credit: 'Made by somebody',
        iconUrl: 'https://img.url',
      )
    ];
    ICategoryService service;
    CategoryCubit subject;

    setUp(() {
      service = MockCategoryService();
      subject = CategoryCubit(service);
    });

    tearDown(() {
      subject.close();
    });

    group('fetch', () {
      blocTest<CategoryCubit, CategoryState>(
        'emits [State(status: loadInProgress, data: []), State(status: loadSuccess, data: [TransactionCategory])], when successful',
        build: () {
          when(service.fetchCategories())
              .thenAnswer((_) async => Right(categories));
          return subject;
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          CategoryState(status: FetchStatus.loadInProgress()),
          CategoryState(status: FetchStatus.loadSuccess(), data: categories),
        ],
      );

      blocTest<CategoryCubit, CategoryState>(
        'emits [State(status: loadInProgress, data: []), State(status: loadFailure, data: [])], when failure',
        build: () {
          when(service.fetchCategories())
              .thenAnswer((_) async => Left(ServerError.networkError()));
          return subject;
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          CategoryState(status: FetchStatus.loadInProgress()),
          CategoryState(
            status: FetchStatus.loadFailure(
              error: ServerError.networkError(),
            ),
          ),
        ],
      );
    });
  });
}
