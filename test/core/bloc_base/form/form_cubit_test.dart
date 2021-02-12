import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_base/form/form_cubit.dart';
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
    FormCubit subject;

    setUp(() {
      api = MockApi();
      subject = FormCubit<String>(api.call);
    });

    tearDown(() {
      subject.close();
    });

    blocTest<FormCubit, FormState>(
      'clear',
      build: () => subject,
      act: (cubit) => cubit.clear(),
      expect: [FormState.initial()],
    );

    group('submit', () {
      final dto = 'john@email.com';
      final serverError = ServerError.unknownError();
      blocTest<FormCubit, FormState>(
        'when success',
        build: () {
          when(api.call(dto)).thenAnswer((_) async => Right(None()));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormState(status: FormStatus.loading()),
          FormState(status: FormStatus.success()),
        ],
      );

      blocTest<FormCubit, FormState>(
        'when failure',
        build: () {
          when(api.call(dto)).thenAnswer((_) async => Left(serverError));
          return subject;
        },
        act: (cubit) => cubit.submit(dto),
        expect: [
          FormState(status: FormStatus.loading()),
          FormState(status: FormStatus.error(error: serverError)),
        ],
      );
    });
  });
}
