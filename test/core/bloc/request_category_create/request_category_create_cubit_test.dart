import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/request_category_create/request_category_create_cubit.dart';
import 'package:geldstroom/core/network/dto/dto.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/core/network/service/service.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/request_category_json.dart';

class MockIRequestCategoryService extends Mock
    implements IRequestCategoryService {}

void main() {
  group('RequestCategoryCategoryCubit', () {
    IRequestCategoryService service;
    RequestCategoryCreateCubit subject;

    final serverError = ServerError.unknownError();
    final data = RequestCategory.fromJson(RequestCategoryJson.list[0]);
    final dto = RequestCategoryCreateDto(
      name: data.categoryName,
      description: data.description,
    );

    setUp(() {
      service = MockIRequestCategoryService();
      subject = RequestCategoryCreateCubit(service);
    });

    tearDown(() {
      subject.close();
    });

    group('submit', () {
      blocTest<RequestCategoryCreateCubit, FormStatusData<RequestCategory>>(
        'when successful',
        build: () {
          when(service.create(dto)).thenAnswer((_) async => Right(data));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormStatusData<RequestCategory>.loading(),
          FormStatusData<RequestCategory>.success(data: data),
        ],
      );

      blocTest<RequestCategoryCreateCubit, FormStatusData<RequestCategory>>(
        'when failure',
        build: () {
          when(service.create(dto)).thenAnswer((_) async => Left(serverError));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormStatusData<RequestCategory>.loading(),
          FormStatusData<RequestCategory>.error(error: serverError),
        ],
      );
    });

    blocTest<RequestCategoryCreateCubit, FormStatusData<RequestCategory>>(
      'clear',
      build: () => subject,
      act: (cubit) => cubit.clear(),
      expect: [FormStatusData<RequestCategory>.idle()],
    );
  });
}
