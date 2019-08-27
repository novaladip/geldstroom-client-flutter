import 'package:geldstroom/models/balance.dart';
import 'package:geldstroom/models/query_params_transaction.dart';
import 'package:geldstroom/utils/api.dart';

class BalanceService {
  Future<Balance> fetchBalance(QueryParamsTransaction queryParams) async {
    try {
      final response =
          await api.get(Url.getBalance, queryParameters: queryParams.params);
      final income = int.tryParse(response.data[0]['INCOME']);
      final expense = int.tryParse(response.data[1]['EXPENSE']);

      return Balance(
        income: income != null ? income : 0,
        expense: expense != null ? expense : 0,
      );
    } catch (error) {
      throw error;
    }
  }
}
