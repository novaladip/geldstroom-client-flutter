import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/model/error_model.dart';

void main() {
  group('ServerError', () {
    test('Equatable test', () {
      final networkError = ServerError.networkError();
      final unknownError = ServerError.unknownError();

      expect(networkError == unknownError, false);
    });
  });
}
