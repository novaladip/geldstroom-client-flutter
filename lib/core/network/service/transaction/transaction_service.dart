import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/dto.dart';
import '../../model/model.dart';

abstract class ITransactionService {
  Future<Either<ServerError, TransactionTotal>> getBalance(GetBalanceDto dto);
  Future<Either<ServerError, List<Transaction>>> getTransactions();
}

@Injectable(as: ITransactionService)
class TransactionService implements ITransactionService {
  TransactionService(this._dio);

  final Dio _dio;

  @override
  Future<Either<ServerError, TransactionTotal>> getBalance(
      GetBalanceDto dto) async {
    try {
      final res = await _dio.get(
        '/transaction/balance',
        queryParameters: dto.toMap,
      );
      final transactionTotal = TransactionTotal.fromJson(res.data);
      return Right(transactionTotal);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, List<Transaction>>> getTransactions() {
    // TODO: implement getTransactions
    throw UnimplementedError();
  }
}
