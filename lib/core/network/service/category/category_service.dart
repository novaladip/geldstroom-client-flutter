import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../model/model.dart';

// ignore: one_member_abstracts
abstract class ICategoryService {
  Future<Either<ServerError, List<TransactionCategory>>> fetchCategories();
}

@Injectable(as: ICategoryService)
class CategoryService implements ICategoryService {
  const CategoryService(this._dio);
  final Dio _dio;

  @override
  Future<Either<ServerError, List<TransactionCategory>>>
      fetchCategories() async {
    try {
      final res = await _dio.get('/category');
      final data = res.data;
      final categories = (data as List)
          .map((json) => TransactionCategory.fromJson(json))
          .toList();
      return Right(categories);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }
}
