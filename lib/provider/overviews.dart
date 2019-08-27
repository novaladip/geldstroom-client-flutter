import 'package:flutter/foundation.dart';
import 'package:geldstroom/models/balance.dart';
import 'package:geldstroom/models/query_params_transaction.dart';
import 'package:geldstroom/models/transaction.dart';
import 'package:geldstroom/provider/services/balance_service.dart';
import 'package:geldstroom/provider/services/transaction_service.dart';

class Overviews with ChangeNotifier {
  TransactionServices _transactionServices = TransactionServices();
  BalanceService _balanceService = BalanceService();
  List<Transaction> _transaction = [];
  Balance _balance = Balance(expense: 0, income: 0);
  bool _isTransactionEmpty = false;
  final today = '2019/08/27';

  List<Transaction> get transaction {
    return [..._transaction];
  }

  bool get isTransactionEmpty {
    return _isTransactionEmpty;
  }

  Balance get balance {
    return _balance;
  }

  Future<void> fetchTransactions() async {
    try {
      final queryParamater = QueryParamsTransaction(
        date: today,
        type: TransactionType.ALL,
        category: TransactionCategory.ALL,
        isMonthly: IsMonthly.DAILY,
        page: 1,
        limit: 5,
      );
      final transactions =
          await _transactionServices.fetchTransactions(queryParamater);
      _isTransactionEmpty = transactions.isEmpty;
      _transaction = transactions;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchBalance() async {
    try {
      final queryParamater = QueryParamsTransaction(
        date: today,
        type: TransactionType.ALL,
        category: TransactionCategory.ALL,
        isMonthly: IsMonthly.DAILY,
        page: 1,
        limit: 0,
      );
      final balance = await _balanceService.fetchBalance(queryParamater);

      _balance = balance;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
