import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../model/model.dart';

// ignore: one_member_abstracts
abstract class IUserService {
  Future<Either<ServerError, Profile>> getProfile();
}

@lazySingleton
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
}
