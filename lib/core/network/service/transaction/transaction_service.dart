import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/dto.dart';
import '../../model/model.dart';

abstract class ITransactionService {
  Future<Either<ServerError, TransactionTotal>> getBalance(GetBalanceDto dto);
  Future<Either<ServerError, List<Transaction>>> getTransactions(
    GetTransactionDto dto,
  );
  Future<Either<ServerError, Transaction>> edit(TransactionEditDto dto);
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
  Future<Either<ServerError, List<Transaction>>> getTransactions(
      GetTransactionDto dto) async {
    try {
      final res = await _dio.get(
        '/transaction',
        queryParameters: dto.toMap,
      );
      final data = res.data;
      final transactionList =
          (data as List).map((json) => Transaction.fromJson(json)).toList();
      return Right(transactionList);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, Transaction>> edit(TransactionEditDto dto) async {
    try {
      final res = await _dio.put(
        '/transaction',
        queryParameters: dto.toMap,
      );
      final data = res.data;
      final transaction = Transaction.fromJson(data);
      return Right(transaction);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }
}
