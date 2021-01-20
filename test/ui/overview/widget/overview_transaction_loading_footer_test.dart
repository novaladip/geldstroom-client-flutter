import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/ui/overview/widget/overview_transaction_loading_footer.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/tranasction_json.dart';
import '../../../test_helper.dart';

class MockOverviewTransactionBloc extends MockBloc<OverviewTransactionState>
    implements OverviewTransactionBloc {}

void main() {
  group('OverviewTransactionLoadingFooter', () {
    OverviewTransactionBloc bloc;
    Widget subject;

    setUp(() {
      bloc = MockOverviewTransactionBloc();
      subject = buildTestableWidget(
        BlocProvider.value(
          value: bloc,
          child: OverviewTransactionLoadingFooter(),
        ),
      );
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets(
        'loading indicator is visible when status is FetchMoreInProgress',
        (tester) async {
      when(bloc.state).thenReturn(
        OverviewTransactionState(
          data: List<Transaction>.generate(
            2,
            (_) => Transaction.fromJson(TransactionJson.listTransaction[0]),
          ),
          isReachEnd: false,
          status: FetchStatus.fetchMoreInProgress(),
        ),
      );
      await tester.pumpWidget(subject);
      expect(find.byType(SpinKitCircle), findsOneWidget);
    });

    testWidgets(
        'loading indicator is not visible when status is FetchMoreInProgress',
        (tester) async {
      when(bloc.state).thenReturn(
        OverviewTransactionState(
          data: List<Transaction>.generate(
            2,
            (_) => Transaction.fromJson(TransactionJson.listTransaction[0]),
          ),
          isReachEnd: false,
          status: FetchStatus.loadSuccess(),
        ),
      );
      await tester.pumpWidget(subject);
      expect(find.byType(SpinKitCircle), findsNothing);
    });
  });
}
