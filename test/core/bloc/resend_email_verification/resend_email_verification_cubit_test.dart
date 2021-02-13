import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

class MockIAuthService extends Mock implements IAuthService {}

void main() {
  group('ResendEmailVerificationCubit', () {
    IAuthService service;
    ResendEmailVerificationCubit subject;

    setUp(() {
      service = MockIAuthService();
      subject = ResendEmailVerificationCubit(service);
    });

    tearDown(() {
      subject.close();
    });

    test('initial value', () {
      expect(subject.state, FormNoneState.initial());
    });
  });
}
