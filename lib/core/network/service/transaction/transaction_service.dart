import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../dto/dto.dart';
import '../../model/model.dart';

abstract class ITransactionService {
  Future<Either<ServerError, TransactionTotal>> getBalance(
      BalanceFilterDto dto);
  Future<Either<ServerError, TransactionReport>> getBalanceReport(
      BalanceFilterDto dto);
  Future<Either<ServerError, List<Transaction>>> getTransactions(
    TransactionFilterDto dto,
  );
  Future<Either<ServerError, Transaction>> create(TransactionCreateDto dto);
  Future<Either<ServerError, Transaction>> edit(TransactionEditDto dto);
  Future<Either<ServerError, None>> deleteOneById(String transactionId);
}

@Injectable(as: ITransactionService)
class TransactionService implements ITransactionService {
  TransactionService(this._dio);

  final Dio _dio;

  @override
  Future<Either<ServerError, TransactionTotal>> getBalance(
      BalanceFilterDto dto) async {
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
  Future<Either<ServerError, TransactionReport>> getBalanceReport(
      BalanceFilterDto dto) async {
    try {
      final res = await _dio.get(
        '/transaction/balance/report',
        queryParameters: dto.toMap,
      );
      final transactionReport = TransactionReport.fromJson(res.data);
      return Right(transactionReport);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, List<Transaction>>> getTransactions(
      TransactionFilterDto dto) async {
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
        '/transaction/${dto.id}',
        data: dto.toMap,
      );
      final data = res.data;
      final transaction = Transaction.fromJson(data);
      return Right(transaction);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, None>> deleteOneById(String transactionId) async {
    try {
      await _dio.delete('/transaction/$transactionId');
      return Right(None());
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }

  @override
  Future<Either<ServerError, Transaction>> create(
      TransactionCreateDto dto) async {
    try {
      final res = await _dio.post(
        '/transaction',
        data: dto.toMap,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );
      final data = Transaction.fromJson(res.data);
      return Right(data);
    } on DioError catch (e) {
      return Left(ServerError.fromDioError(e));
    }
  }
}
