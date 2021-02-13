import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/dto.dart';
import '../../model/model.dart';

abstract class IAuthService {
  Future<Either<ServerError, String>> loginWithEmail(LoginDto dto);
  Future<Either<ServerError, None>> register(RegisterDto dto);
  Future<Either<ServerError, None>> requestOtp(String email);
  Future<Either<ServerError, None>> resetPassword(PasswordResetDto dto);
  Future<Either<ServerError, None>> resendEmailVerification(String email);
}

@Injectable(as: IAuthService)
class AuthService implements IAuthService {
  const AuthService(this._dio);

  final Dio _dio;

  @override
  Future<Either<ServerError, String>> loginWithEmail(LoginDto dto) async {
    try {
      final res = await _dio.post('/user/login', data: dto.toMap);
      final accessToken = res.data['accessToken'];
      return Right(accessToken);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, None>> register(RegisterDto dto) async {
    try {
      await _dio.post('/user/register', data: dto.toMap);
      return Right(None());
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, None>> requestOtp(String email) async {
    try {
      await _dio.post('/user/request/otp', data: {'email': email});
      return Right(None());
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, None>> resetPassword(PasswordResetDto dto) async {
    try {
      await _dio.put('/user/reset/password', data: dto.toMap);
      return Right(None());
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, None>> resendEmailVerification(
    String email,
  ) async {
    try {
      await _dio.post('/user/verify/resend', data: {'email': email});
      return Right(None());
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }
}
