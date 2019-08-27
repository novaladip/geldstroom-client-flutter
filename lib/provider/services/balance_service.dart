import 'package:geldstroom/models/balance.dart';
import 'package:geldstroom/models/query_params_transaction.dart';
import 'package:geldstroom/utils/api.dart';

class BalanceService {
  Future<Balance> fetchBalance(QueryParamsTransaction queryParams) async {
    try {
      final response =
          await api.get(Url.getBalance, queryParameters: queryParams.params);

      final String income = response.data[0]['INCOME'];
      final String expense = response.data[1]['EXPENSE'];

      final balance = Balance(
        income: income != null ? int.parse(income) : 0,
        expense: expense != null ? int.parse(expense) : 0,
      );

      return balance;
    } catch (error) {
      throw error;
    }
  }
}
