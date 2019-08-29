import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:geldstroom/models/balance.dart';
import 'package:geldstroom/models/post_transaction_body.dart';

import 'package:geldstroom/models/query_params_transaction.dart';
import 'package:geldstroom/models/transaction.dart';
import 'package:geldstroom/provider/services/balance_service.dart';
import 'package:geldstroom/provider/services/transaction_service.dart';

class Records with ChangeNotifier {
  final _transactionService = TransactionServices();
  final _balanceService = BalanceService();

  Balance _balance = Balance(expense: 0, income: 0);
  List<Transaction> _transaction = [];
  bool _isEmpty = false;
  bool _isOnLastPage = false;
  int _currentPage = 1;
  int _limit = 10;

  List<Transaction> get transaction {
    return [..._transaction];
  }

  Balance get balance {
    return _balance;
  }

  int get currentPage {
    return _currentPage;
  }

  bool get isOnLastPage {
    return _isOnLastPage;
  }

  bool get isEmpty {
    return _isEmpty;
  }

  Future<void> postTransaction(PostTransactionBody postTransactionBody) async {
    try {
      final transaction =
          await _transactionService.postTransaction(postTransactionBody);
      _transaction = [transaction, ..._transaction];
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchRecords(
    String date, {
    TransactionType type,
    TransactionCategory category,
    IsMonthly isMonthly,
  }) async {
    try {
      _currentPage = 1;
      _isEmpty = false;
      final params = QueryParamsTransaction(
        date: date,
        type: type,
        category: category,
        isMonthly: isMonthly,
        page: _currentPage,
        limit: _limit,
      );

      final transactions = await _transactionService.fetchTransactions(params);
      _transaction = transactions;
      _currentPage = 1;
      notifyListeners();
    } on DioError catch (error) {
      throw error;
    }
  }

  Future<void> loadMoreTransactions(
    String date, {
    TransactionType type,
    TransactionCategory category,
    IsMonthly isMonthly,
  }) async {
    try {
      final transaction =
          await _transactionService.fetchTransactions(QueryParamsTransaction(
        date: date,
        type: type,
        category: category,
        isMonthly: isMonthly,
        page: _currentPage + 1,
        limit: _limit,
      ));
      if (transaction.isEmpty) {
        _isOnLastPage = true;
        return;
      }
      _transaction = [..._transaction, ...transaction];
      _currentPage += 1;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchBalance(
    String date, {
    TransactionType type,
    TransactionCategory category,
    IsMonthly isMonthly,
  }) async {
    try {
      final params = QueryParamsTransaction(
        date: date,
        type: type,
        category: category,
        isMonthly: isMonthly,
        page: 1,
        limit: 0,
      );
      final balance = await _balanceService.fetchBalance(params);
      _balance = balance;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void clearState() {
    _balance = Balance(income: 0, expense: 0);
    _transaction = [];
    notifyListeners();
  }
}
