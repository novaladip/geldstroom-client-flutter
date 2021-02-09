import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../overview_balance/overview_balance_cubit_test.dart';

class MockITransactionService extends Mock implements ITransactionService {}

void main() {
  group('TransactionDeleteCubit', () {
    ITransactionService service;

    setUp(() {
      service = MockTransactionService();
    });

    test('initial value', () {
      final subject = TransactionDeleteCubit(service);
      expect(subject.state, DeleteState.initial());
    });
  });
}
