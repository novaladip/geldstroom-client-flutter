import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_base/form_none/form_none_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

// ignore: one_member_abstracts
abstract class Api {
  Future<Either<ServerError, None>> call(String email);
}

class MockApi extends Mock implements Api {}

void main() {
  group('FormCubit', () {
    Api api;
    FormNoneCubit subject;

    setUp(() {
      api = MockApi();
      subject = FormNoneCubit<String>(api.call);
    });

    tearDown(() {
      subject.close();
    });

    blocTest<FormNoneCubit, FormNoneState>(
      'clear',
      build: () => subject,
      act: (cubit) => cubit.clear(),
      expect: [FormNoneState.initial()],
    );

    group('submit', () {
      final dto = 'john@email.com';
      final serverError = ServerError.unknownError();
      blocTest<FormNoneCubit, FormNoneState>(
        'when success',
        build: () {
          when(api.call(dto)).thenAnswer((_) async => Right(None()));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormNoneState(status: FormStatus.loading()),
          FormNoneState(status: FormStatus.success()),
          FormNoneState(status: FormStatus.idle()),
        ],
      );

      blocTest<FormNoneCubit, FormNoneState>(
        'when failure',
        build: () {
          when(api.call(dto)).thenAnswer((_) async => Left(serverError));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormNoneState(status: FormStatus.loading()),
          FormNoneState(status: FormStatus.error(error: serverError)),
        ],
      );
    });
  });
}
