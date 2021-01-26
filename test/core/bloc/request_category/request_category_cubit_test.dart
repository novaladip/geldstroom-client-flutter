import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/request_category/request_category_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/request_category_json.dart';

class MockIRequestCategoryService extends Mock
    implements IRequestCategoryService {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  group('RequestCategoryCubit', () {
    IRequestCategoryService service;
    RequestCategoryCubit subject;
    AuthCubit authCubit;

    final data = RequestCategoryJson.list
        .map((json) => RequestCategory.fromJson(json))
        .toList();
    final serverError = ServerError.networkError();

    setUp(() {
      service = MockIRequestCategoryService();
      authCubit = MockAuthCubit();
      subject = RequestCategoryCubit(service, authCubit);
    });

    tearDown(() {
      authCubit.close();
      subject.close();
    });

    group('fetch', () {
      blocTest<RequestCategoryCubit, RequestCategoryState>(
        'when successful',
        build: () {
          when(service.getAll()).thenAnswer((_) async => Right(data));
          return subject;
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          RequestCategoryState(
            data: [],
            status: FetchStatus.loadInProgress(),
          ),
          RequestCategoryState(
            data: data,
            status: FetchStatus.loadSuccess(),
          ),
        ],
      );

      blocTest<RequestCategoryCubit, RequestCategoryState>(
        'when failure',
        build: () {
          when(service.getAll()).thenAnswer((_) async => Left(serverError));
          return subject;
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          RequestCategoryState(
            data: [],
            status: FetchStatus.loadInProgress(),
          ),
          RequestCategoryState(
            data: [],
            status: FetchStatus.loadFailure(error: serverError),
          ),
        ],
      );
    });

    group('listen AuthState', () {
      blocTest<RequestCategoryCubit, RequestCategoryState>(
        'call clear when state is AuthStateUnauthenticated',
        build: () {
          whenListen(authCubit, Stream.value(AuthState.unauthenticated()));
          return RequestCategoryCubit(service, authCubit);
        },
        expect: [RequestCategoryState.initial()],
      );
    });
  });
}
