import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/bloc/overview_transaction/overview_transaction_bloc.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/ui/home/home_page.dart';
import 'package:geldstroom/ui/home/widget/overview_balance.dart';
import 'package:geldstroom/ui/home/widget/overview_range_form.dart';
import 'package:geldstroom/ui/home/widget/overview_transaction.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helper_tests/tranasction_json.dart';
import '../../test_helper.dart';

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

class MockOverviewBalanceCubit extends MockBloc<OverviewBalanceState>
    implements OverviewBalanceCubit {}

class MockOverviewTransactionBloc extends MockBloc<OverviewTransactionState>
    implements OverviewTransactionBloc {}

class MockTransactionDeleteCubit extends MockBloc<TransactionDeleteState>
    implements TransactionDeleteCubit {}

void main() {
  group('HomePage', () {
    Widget subject;
    OverviewRangeCubit overviewRangeCubit;
    OverviewBalanceCubit overviewBalanceCubit;
    OverviewTransactionBloc overviewTransactionBloc;
    TransactionDeleteCubit transactionDeleteCubit;

    setUp(() {
      overviewRangeCubit = MockOverviewRangeCubit();
      overviewBalanceCubit = MockOverviewBalanceCubit();
      overviewTransactionBloc = MockOverviewTransactionBloc();
      transactionDeleteCubit = MockTransactionDeleteCubit();
      when(transactionDeleteCubit.state)
          .thenReturn(TransactionDeleteState.initial());
      when(overviewTransactionBloc.state).thenReturn(
        OverviewTransactionState(
          status: FetchStatus.loadSuccess(),
          isReachEnd: true,
        ),
      );
      subject = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: overviewRangeCubit),
          BlocProvider.value(value: overviewBalanceCubit),
          BlocProvider.value(value: overviewTransactionBloc),
          BlocProvider.value(value: transactionDeleteCubit),
        ],
        child: buildTestableBlocWidget(
          initialRoutes: HomePage.routeName,
          routes: {
            HomePage.routeName: (_) => mockNetworkImagesFor(() => HomePage()),
          },
        ),
      );
    });

    tearDown(() {
      overviewTransactionBloc.close();
      overviewBalanceCubit.close();
      transactionDeleteCubit.close();
      overviewRangeCubit.close();
    });

    testWidgets('renders correctly', (tester) async {
      when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
      when(overviewBalanceCubit.state)
          .thenReturn(OverviewBalanceState.initial());
      when(overviewTransactionBloc.state).thenReturn(
        OverviewTransactionState(
          status: FetchStatus.loadInProgress(),
          isReachEnd: true,
        ),
      );
      await tester.pumpWidget(subject);

      expect(find.text(HomePage.appBarTitle), findsOneWidget);
      expect(find.byType(OverviewBalance), findsOneWidget);
      expect(find.byType(OverviewTransaction), findsOneWidget);
      expect(
        find.byKey(HomePage.overviewRangeIconKey).hitTestable(),
        findsOneWidget,
      );
    });

    testWidgets(
        'should able to show OverviewRangeForm by tapping overview range icon',
        (tester) async {
      when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
      when(overviewBalanceCubit.state)
          .thenReturn(OverviewBalanceState.initial());
      await tester.pumpWidget(subject);

      final icon = find.byKey(HomePage.overviewRangeIconKey).hitTestable();
      await tester.tap(icon);
      await tester.pumpAndSettle();
      expect(find.byType(OverviewRangeForm), findsOneWidget);
    });

    group('listen TransactionEditState', () {
      testWidgets('should show snackbar when onDeleteSuccessIds is changed',
          (tester) async {
        whenListen(
          transactionDeleteCubit,
          Stream.fromIterable([
            TransactionDeleteState(
              onDeleteFailureIds: [],
              onDeleteProgressIds: [],
              onDeleteSuccessIds: ['1'],
            ),
          ]),
        );
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());
        when(overviewTransactionBloc.state).thenReturn(
          OverviewTransactionState(
            status: FetchStatus.loadSuccess(),
            data: List<Transaction>.generate(
              15,
              (_) => Transaction.fromJson(TransactionJson.listTransaction[0]),
            ),
            isReachEnd: false,
          ),
        );
        await tester.pumpWidget(subject);
        await tester.pump(Duration(seconds: 1));
        expect(find.text('Transaction has been deleted'), findsOneWidget);
      });

      testWidgets('should show snackbar when onDeleteFailureIds is changed',
          (tester) async {
        whenListen(
          transactionDeleteCubit,
          Stream.fromIterable([
            TransactionDeleteState(
              onDeleteFailureIds: ['1'],
              onDeleteProgressIds: [],
              onDeleteSuccessIds: [],
            ),
          ]),
        );
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());
        when(overviewTransactionBloc.state).thenReturn(
          OverviewTransactionState(
            status: FetchStatus.loadSuccess(),
            data: List<Transaction>.generate(
              15,
              (_) => Transaction.fromJson(TransactionJson.listTransaction[0]),
            ),
            isReachEnd: false,
          ),
        );
        await tester.pumpWidget(subject);
        await tester.pump(Duration(seconds: 1));
        expect(find.text('Failed to delete transaction'), findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets(
          'when pull to refresh should add OverviewTransactionEvent.fetch',
          (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());
        when(overviewTransactionBloc.state).thenReturn(
          OverviewTransactionState(
            status: FetchStatus.loadSuccess(),
            data: List<Transaction>.generate(
              15,
              (_) => Transaction.fromJson(TransactionJson.listTransaction[0]),
            ),
            isReachEnd: false,
          ),
        );
        await tester.pumpWidget(subject);

        await tester.drag(
          find.byType(OverviewBalance),
          const Offset(0.0, 300.0),
          touchSlopY: 0,
        );

        await tester.pumpAndSettle();

        verify(overviewBalanceCubit.fetch()).called(2);
        verify(
          overviewTransactionBloc.add(OverviewTransactionEvent.fetch()),
        ).called(2);
      });

      testWidgets(
          'add OverviewTransactionEvent.fetchMore when scroll reach end',
          (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());
        when(overviewTransactionBloc.state).thenReturn(
          OverviewTransactionState(
            status: FetchStatus.loadSuccess(),
            data: List<Transaction>.generate(
              15,
              (_) => Transaction.fromJson(TransactionJson.listTransaction[0]),
            ),
            isReachEnd: false,
          ),
        );
        await tester.pumpWidget(subject);
        await tester.drag(
          find.byKey(HomePage.customScrollViewKey),
          Offset(0, -1000),
        );
        verify(
          overviewTransactionBloc.add(OverviewTransactionEvent.fetchMore()),
        ).called(1);
      });
    });
  });
}
