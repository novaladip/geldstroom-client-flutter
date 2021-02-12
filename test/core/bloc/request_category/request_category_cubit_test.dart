import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/request_category/request_category_cubit.dart';
import 'package:geldstroom/core/bloc/request_category_create/request_category_create_cubit.dart';
import 'package:geldstroom/core/bloc/request_category_delete/request_category_delete_cubit.dart';
import 'package:geldstroom/core/bloc_base/delete/delete_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/request_category_json.dart';

class MockIRequestCategoryService extends Mock
    implements IRequestCategoryService {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

class MockRequestCategoryDeleteCubit extends MockBloc<DeleteState>
    implements RequestCategoryDeleteCubit {}

class MockRequestCategoryCreate
    extends MockBloc<FormStatusData<RequestCategory>>
    implements RequestCategoryCreateCubit {}

void main() {
  group('RequestCategoryCubit', () {
    IRequestCategoryService service;
    RequestCategoryCubit subject;
    AuthCubit authCubit;
    RequestCategoryCreateCubit requestCategoryCreateCubit;
    RequestCategoryDeleteCubit requestCategoryDeleteCubit;

    final data = RequestCategoryJson.list
        .map((json) => RequestCategory.fromJson(json))
        .toList();
    final serverError = ServerError.networkError();

    setUp(() {
      service = MockIRequestCategoryService();
      authCubit = MockAuthCubit();
      requestCategoryCreateCubit = MockRequestCategoryCreate();
      requestCategoryDeleteCubit = MockRequestCategoryDeleteCubit();
      subject = RequestCategoryCubit(
        service,
        authCubit: authCubit,
        requestCategoryCreateCubit: requestCategoryCreateCubit,
        requestCategoryDeleteCubit: requestCategoryDeleteCubit,
      );
    });

    tearDown(() {
      authCubit.close();
      subject.close();
      requestCategoryCreateCubit.close();
      requestCategoryDeleteCubit.close();
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
          return RequestCategoryCubit(
            service,
            authCubit: authCubit,
            requestCategoryCreateCubit: requestCategoryCreateCubit,
            requestCategoryDeleteCubit: requestCategoryDeleteCubit,
          );
        },
        expect: [RequestCategoryState.initial()],
      );
    });

    group('listen RequestCategoryDeleteCubit', () {
      final initialState = RequestCategoryState(
        data: data,
        status: FetchStatus.loadSuccess(),
      );
      final stateAfterDelete = initialState.copyWith(
        data: data.where((item) => item.id != data[0].id).toList(),
      );
      blocTest<RequestCategoryCubit, RequestCategoryState>(
        'call _onDelete every time shouldListenDeleteSuccess return true',
        seed: initialState,
        build: () {
          final deleteState = DeleteState(
            onDeleteFailureIds: [],
            onDeleteProgressIds: [],
            onDeleteSuccessIds: [data[0].id],
          );
          whenListen(
            requestCategoryDeleteCubit,
            Stream.value(deleteState),
          );
          return RequestCategoryCubit(
            service,
            authCubit: authCubit,
            requestCategoryCreateCubit: requestCategoryCreateCubit,
            requestCategoryDeleteCubit: requestCategoryDeleteCubit,
          );
        },
        expect: [stateAfterDelete],
      );
    });

    group('listen RequestCategoryCreateCubit', () {
      blocTest<RequestCategoryCubit, RequestCategoryState>(
        'call _add every time create success occurred',
        build: () {
          whenListen(
            requestCategoryCreateCubit,
            Stream.value(
                FormStatusData<RequestCategory>.success(data: data[0])),
          );
          return RequestCategoryCubit(
            service,
            authCubit: authCubit,
            requestCategoryCreateCubit: requestCategoryCreateCubit,
            requestCategoryDeleteCubit: requestCategoryDeleteCubit,
          );
        },
        expect: [
          RequestCategoryState(
            status: FetchStatus.initial(),
            data: [data[0]],
          ),
        ],
      );
    });
  });
}
