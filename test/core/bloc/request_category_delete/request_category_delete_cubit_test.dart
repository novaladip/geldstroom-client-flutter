import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/request_category_delete/request_category_delete_cubit.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';
import 'package:geldstroom/core/network/service/request_category/request_category_service.dart';
import 'package:mockito/mockito.dart';

class MockIRequestCategoryService extends Mock
    implements IRequestCategoryService {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

void main() {
  group('RequestCategoryDelete', () {
    IRequestCategoryService service;
    AuthCubit authCubit;

    setUp(() {
      service = MockIRequestCategoryService();
      authCubit = MockAuthCubit();
    });

    test('initial value', () {
      final subject = RequestCategoryDeleteCubit(
        service: service,
        authCubit: authCubit,
      );
      expect(subject.state, DeleteState.initial());
    });

    group('listen', () {
      group('listen for AuthCubit', () {
        blocTest(
          'call clear when state is AuthStateUnauthenticated',
          build: () {
            whenListen(authCubit, Stream.value(AuthState.unauthenticated()));
            when(authCubit.state).thenReturn(AuthState.unauthenticated());
            return RequestCategoryDeleteCubit(
              service: service,
              authCubit: authCubit,
            );
          },
          expect: [DeleteState.initial()],
        );
      });
    });
  });
}
