import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/dto.dart';
import '../../model/model.dart';

abstract class IUserService {
  Future<Either<ServerError, Profile>> getProfile();
  Future<Either<ServerError, None>> changePassword(ChangePasswordDto dto);
}

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  const UserService(this._dio);

  final Dio _dio;

  @override
  Future<Either<ServerError, Profile>> getProfile() async {
    try {
      final res = await _dio.get('/user/me');
      final data = Profile.fromJson(res.data);
      return Right(data);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, None>> changePassword(
      ChangePasswordDto dto) async {
    try {
      await _dio.post(
        '/user/change/password',
        data: dto.toMap,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      return Right(None());
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }
}
