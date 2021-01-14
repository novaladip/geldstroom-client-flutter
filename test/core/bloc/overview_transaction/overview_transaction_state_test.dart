import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/overview_transaction/overview_transaction_bloc.dart';
import 'package:geldstroom/core/network/network.dart';

import '../../../helper_tests/tranasction_json.dart';

void main() {
  group('OverviewTransactionState', () {
    group('extension', () {
      group('isEmpty', () {
        test('return true when status is LoadSuccess and data isEmpty is true',
            () {
          final state = OverviewTransactionState(
            data: [],
            status: FetchStatus.loadSuccess(),
          );
          expect(state.isEmpty, true);
        });

        test(
            'return false when status is LoadSuccess and data isEmpty is false',
            () {
          final state = OverviewTransactionState(
            data: [Transaction.fromJson(TransactionJson.listTransaction[0])],
            status: FetchStatus.loadSuccess(),
          );
          expect(state.isEmpty, false);
        });

        test('return false when status is not LoadSuccess', () {
          final state = OverviewTransactionState(
            data: [],
            status: FetchStatus.loadInProgress(),
          );
          expect(state.isEmpty, false);
        });
      });
    });
  });
}
