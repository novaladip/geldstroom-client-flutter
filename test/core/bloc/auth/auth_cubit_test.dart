import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/shared/common/utils/jwt_ops/jwt_ops.dart';
import 'package:mockito/mockito.dart';

const validToken =
    // ignore: lines_longer_than_80_chars
    'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3RAZ21haWwuY29tIiwiZXhwIjoxOTE5NTk1Nzg0LCJpZCI6ImZlYWYxYzA0LTZhNDYtNGRhNi04NDExLTE2OWNiMWYxZjY5ZSIsImlzQWRtaW4iOnRydWV9.Ymu_8Ivv3dtcGRqGMDgAfyldP8-Cfw7TZ-GdjaVDpxvcAMF_phYBCVFA2X4-O8lxOZijIqreYj-8gbxLN4U3Aw';

const invalidToken =
    // ignore: lines_longer_than_80_chars
    'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3RAZ21haWwuY29tIiwiZXhwIjoxNTE5NTk1Nzg0LCJpZCI6ImZlYWYxYzA0LTZhNDYtNGRhNi04NDExLTE2OWNiMWYxZjY5ZSIsImlzQWRtaW4iOnRydWV9.6LmijvmrQqZ2SPNtcRfScplC66Q8OKlN0TdgvAePW2M73gqdMHYwqT1QMJ_DVsfh9dvLJY-faTnZ8-_D1RhQdQ';

class MockJwtOps extends Mock implements JwtOps {}

class MockOverviewBalanceCubit extends MockBloc<OverviewBalanceState>
    implements OverviewBalanceCubit {}

void main() {
  group('AuthCubit', () {
    JwtOps mockJwtOps;

    setUp(() {
      mockJwtOps = MockJwtOps();
    });
    group('appStarted()', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthState.authenticated] when a valid token is saved',
        build: () {
          when(mockJwtOps.getToken()).thenReturn(validToken);
          return AuthCubit(mockJwtOps);
        },
        act: (cubit) => cubit.appStarted(),
        expect: [AuthState.authenticated()],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthState.unauthenticated] when a expired token is saved',
        build: () {
          when(mockJwtOps.getToken()).thenReturn(invalidToken);
          return AuthCubit(mockJwtOps);
        },
        act: (cubit) => cubit.appStarted(),
        expect: [AuthState.unauthenticated()],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthState.unauthenticated] when there is no token saved',
        build: () {
          when(mockJwtOps.getToken()).thenReturn(null);
          return AuthCubit(mockJwtOps);
        },
        act: (cubit) => cubit.appStarted(),
        expect: [AuthState.unauthenticated()],
      );
    });

    group('loggedIn()', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthState.authenticated] when called with a given token '
        'should verify JwtOps.setDefaultHeader() is called with a given token',
        build: () => AuthCubit(mockJwtOps),
        act: (cubit) => cubit.loggedIn(validToken),
        expect: [AuthState.authenticated()],
        verify: (_) {
          verify(mockJwtOps.setDefaultAuthHeader(validToken));
        },
      );
    });

    group('loggedOut()', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthState.unauthenticated] when called with an empty string',
        build: () => AuthCubit(mockJwtOps),
        act: (cubit) => cubit.loggedOut(),
        expect: [AuthState.unauthenticated()],
      );
    });
  });
}
