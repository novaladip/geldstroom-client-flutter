import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/model/error_model.dart';

void main() {
  group('ServerError', () {
    test('Equatable test', () {
      final networkError = ServerError.networkError();
      final unknownError = ServerError.unknownError();

      expect(networkError == unknownError, false);
    });

    test('fromJson test', () {
      final json = {
        'message': 'some error',
        'errorCode': 'ERROR_CODE_400',
        'error': {'email': 'Invalid email address'}
      };
      final serverError = ServerError.fromJson(json);
      expect(serverError.error, json['error']);
      expect(serverError.message, json['message']);
      expect(serverError.errorCode, json['errorCode']);
    });
  });
}
