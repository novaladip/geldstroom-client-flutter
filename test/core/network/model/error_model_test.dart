import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/model/error_model.dart';

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

    test(
        'fromDioError should return ServerError.unknownError() '
        'when status code is >= 500', () {
      final error = DioError(
        response: Response(
          statusCode: 500,
          data: {'message': 'Internal server error'},
        ),
      );
      final serverError = ServerError.fromDioError(error);
      expect(serverError, ServerError.unknownError());
    });

    test(
        'fromDioError should return ServerError.networkError() '
        'when response is null', () {
      final error = DioError(response: null);
      final serverError = ServerError.fromDioError(error);
      expect(serverError, ServerError.networkError());
    });

    test(
        'fromDioError should return ServerError.unknownError() '
        'when data is null and statusCode is < 500', () {
      final error = DioError(
        response: Response(data: null, statusCode: 400),
      );
      final serverError = ServerError.fromDioError(error);
      expect(serverError, ServerError.unknownError());
    });
  });
}
