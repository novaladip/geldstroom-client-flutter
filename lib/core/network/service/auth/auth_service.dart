import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/login_dto.dart';
import '../../dto/register_dto.dart';
import '../../model/error_model.dart';

abstract class IAuthService {
  Future<Either<ServerError, String>> loginWithEmail(LoginDto dto);
  Future<Either<ServerError, None>> register(RegisterDto dto);
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
}
