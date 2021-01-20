import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/profile/profile_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/profile_json.dart';

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

class MockIUserService extends MockBloc<IUserService> implements IUserService {}

void main() {
  group('ProfileCubit', () {
    AuthCubit authCubit;
    IUserService service;

    final profile = Profile.fromJson(profileJson);
    final serverError = ServerError.networkError();

    setUp(() {
      authCubit = MockAuthCubit();
      service = MockIUserService();
      when(service.getProfile()).thenAnswer((_) async => Right(profile));
    });

    tearDown(() {
      authCubit.close();
    });

    blocTest<ProfileCubit, ProfileState>(
      'call clear when authState is unauthenticated',
      build: () {
        whenListen(authCubit, Stream.value(AuthState.unauthenticated()));
        return ProfileCubit(
          service,
          authCubit,
        );
      },
      expect: [ProfileState.loadInProgress()],
    );

    group('fetch', () {
      blocTest<ProfileCubit, ProfileState>(
        'when successful',
        build: () => ProfileCubit(service, authCubit),
        act: (cubit) => cubit.fetch(),
        expect: [
          ProfileState.loadInProgress(),
          ProfileState.loadSucess(profile),
        ],
      );

      blocTest<ProfileCubit, ProfileState>(
        'when failure',
        build: () {
          when(service.getProfile()).thenAnswer((_) async => Left(serverError));
          return ProfileCubit(service, authCubit);
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          ProfileState.loadInProgress(),
          ProfileState.loadFailure(serverError),
        ],
      );
    });
  });
}
