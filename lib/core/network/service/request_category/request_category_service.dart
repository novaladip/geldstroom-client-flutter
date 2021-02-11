import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/dto.dart';
import '../../model/model.dart';

abstract class IRequestCategoryService {
  Future<Either<ServerError, RequestCategory>> create(
      RequestCategoryCreateDto dto);
  Future<Either<ServerError, List<RequestCategory>>> getAll();
  Future<Either<ServerError, None>> deleteOneById(String id);
}

@LazySingleton(as: IRequestCategoryService)
class RequestCategoryService implements IRequestCategoryService {
  const RequestCategoryService(this._dio);

  final Dio _dio;

  @override
  Future<Either<ServerError, List<RequestCategory>>> getAll() async {
    try {
      final res = await _dio.get('/request-category');
      final data = res.data;
      final requestCategoryList =
          (data as List).map((json) => RequestCategory.fromJson(json)).toList();
      return Right(requestCategoryList);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, RequestCategory>> create(
      RequestCategoryCreateDto dto) async {
    try {
      final res = await _dio.post(
        '/request-category',
        data: dto.toMap,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      final data = res.data;
      final requestCategory = RequestCategory.fromJson(data);
      return Right(requestCategory);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, None>> deleteOneById(String id) async {
    try {
      final url = '/request-category/$id';
      await _dio.delete(url);
      return Right(None());
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }
}
