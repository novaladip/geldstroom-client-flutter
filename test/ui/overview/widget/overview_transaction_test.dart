// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/ui/overview/widget/overview_transaction.dart';
import 'package:geldstroom/ui/overview/widget/overview_transaction_list.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/tranasction_json.dart';
import '../../../test_helper.dart';

class MockOverviewTransctionBloc extends MockBloc<OverviewTransactionState>
    implements OverviewTransactionBloc {}

class MockTransactionDeleteCubit extends MockBloc<DeleteState>
    implements TransactionDeleteCubit {}

void main() {
  group('OverviewTransaction', () {
    Widget subject;
    OverviewTransactionBloc overviewTransactionBloc;
    TransactionDeleteCubit transactionDeleteCubit;
    final Key overviewTransactionKey = UniqueKey();

    setUp(() {
      overviewTransactionBloc = MockOverviewTransctionBloc();
      transactionDeleteCubit = MockTransactionDeleteCubit();
      when(transactionDeleteCubit.state).thenReturn(DeleteState.initial());
      subject = buildTestableWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: overviewTransactionBloc),
            BlocProvider.value(value: transactionDeleteCubit),
          ],
          child: CustomScrollView(
            slivers: [
              OverviewTransaction(key: overviewTransactionKey),
            ],
          ),
        ),
      );
    });

    group('renders', () {
      testWidgets('should render loading widget when state is loadInProgress',
          (tester) async {
        when(overviewTransactionBloc.state).thenReturn(
          OverviewTransactionState(status: FetchStatus.loadInProgress()),
        );
        await tester.pumpWidget(subject);
        await tester.pump();
        expect(find.byKey(OverviewTransaction.loadingKey), findsOneWidget);
      });

      testWidgets('should render ErrorMessage when status is loadFailure',
          (tester) async {
        when(overviewTransactionBloc.state).thenReturn(
          OverviewTransactionState(
              status:
                  FetchStatus.loadFailure(error: ServerError.networkError())),
        );
        await tester.pumpWidget(subject);
        await tester.pump();
        expect(find.byKey(OverviewTransaction.loadingKey), findsNothing);
        expect(find.text(OverviewTransaction.errorText), findsOneWidget);
        expect(find.byType(SvgPicture), findsOneWidget);
      });

      testWidgets(
          'should render OverviewTransactionList when status is loadSuccess',
          (tester) async {
        when(overviewTransactionBloc.state).thenReturn(
          OverviewTransactionState(
            status: FetchStatus.loadSuccess(),
            data: List<Transaction>.generate(
              5,
              (_) => Transaction.fromJson(TransactionJson.listTransaction[0]),
            ),
          ),
        );
        await tester.pumpWidget(subject);
        await tester.pumpAndSettle();
        expect(find.byType(OverviewTransactionList), findsWidgets);
      });
    });

    group('calls', () {
      testWidgets(
          'should call OverviewTransactionBloc.add(OverviewTransactionEvent.fetch()) on initState',
          (tester) async {
        when(overviewTransactionBloc.state)
            .thenReturn(OverviewTransactionState());
        await tester.pumpWidget(subject);
        await tester.pumpAndSettle();
        verify(
          overviewTransactionBloc.add(OverviewTransactionEvent.fetch()),
        ).called(1);
      });
    });
  });
}
