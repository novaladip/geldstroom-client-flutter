import 'package:dio/dio.dart';
import 'package:geldstroom/models/post_transaction_body.dart';

import 'package:geldstroom/models/query_params_transaction.dart';
import 'package:geldstroom/models/transaction.dart';
import 'package:geldstroom/utils/api.dart';

class TransactionServices {
  Future<List<Transaction>> fetchTransactions(
      QueryParamsTransaction queryParams) async {
    try {
      final response = await api.get(
        Url.getTransaction,
        queryParameters: queryParams.params,
      );
      final data = (response.data as List)
          .map((item) => Transaction.fromJson(item))
          .toList();

      return data;
    } on DioError catch (error) {
      throw error;
    }
  }

  Future<Transaction> fetchTransactionById(String id) async {
    try {
      final response = await api.get(Url.getTransaction + '/$id');
      return Transaction.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }

  Future<Transaction> postTransaction(
      PostTransactionBody postTransactionBody) async {
    try {
      final response =
          await api.post(Url.postTransaction, data: postTransactionBody.toMap);
      return Transaction.fromJson(response.data);
    } catch (error) {
      throw error;
    }
  }
}
