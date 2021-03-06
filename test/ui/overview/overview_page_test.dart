import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc/overview_balance/overview_balance_cubit.dart';
import 'package:geldstroom/core/bloc/overview_transaction/overview_transaction_bloc.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/ui/overview/overview_page.dart';
import 'package:geldstroom/ui/overview/widget/overview_balance.dart';
import 'package:geldstroom/ui/overview/widget/overview_range_form.dart';
import 'package:geldstroom/ui/overview/widget/overview_transaction.dart';
import 'package:geldstroom/ui/transaction_create/transaction_create_page.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helper_tests/tranasction_json.dart';
import '../../test_helper.dart';

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

class MockOverviewBalanceCubit extends MockBloc<OverviewBalanceState>
    implements OverviewBalanceCubit {}

class MockCategoryCubit extends MockBloc<CategoryState>
    implements CategoryCubit {}

class MockOverviewTransactionBloc extends MockBloc<OverviewTransactionState>
    implements OverviewTransactionBloc {}

class MockTransactionCreateCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionCreateCubit {}

class MockTransactionDeleteCubit extends MockBloc<DeleteState>
    implements TransactionDeleteCubit {}

void main() {
  group('OverviewPage', () {
    Widget subject;
    OverviewRangeCubit overviewRangeCubit;
    OverviewBalanceCubit overviewBalanceCubit;
    OverviewTransactionBloc overviewTransactionBloc;
    CategoryCubit categoryCubit;
    TransactionCreateCubit transactionCreateCubit;
    TransactionDeleteCubit transactionDeleteCubit;

    setUp(() {
      overviewRangeCubit = MockOverviewRangeCubit();
      overviewBalanceCubit = MockOverviewBalanceCubit();
      overviewTransactionBloc = MockOverviewTransactionBloc();
      categoryCubit = MockCategoryCubit();
      transactionCreateCubit = MockTransactionCreateCubit();
      transactionDeleteCubit = MockTransactionDeleteCubit();
      when(categoryCubit.state).thenReturn(CategoryState());
      when(transactionCreateCubit.state)
          .thenReturn(FormStatusData<Transaction>.idle());
      when(transactionDeleteCubit.state).thenReturn(DeleteState.initial());
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
          BlocProvider.value(value: transactionCreateCubit),
          BlocProvider.value(value: transactionDeleteCubit),
          BlocProvider.value(value: categoryCubit),
        ],
        child: buildTestableBlocWidget(
          initialRoutes: OverviewPage.routeName,
          routes: {
            OverviewPage.routeName: (_) =>
                mockNetworkImagesFor(() => OverviewPage()),
          },
        ),
      );
    });

    tearDown(() {
      overviewTransactionBloc.close();
      overviewRangeCubit.close();
      overviewBalanceCubit.close();
      transactionDeleteCubit.close();
      overviewRangeCubit.close();
      categoryCubit.close();
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

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text(OverviewPage.appBarTitle), findsOneWidget);
      expect(find.byType(OverviewBalance), findsOneWidget);
      expect(find.byType(OverviewTransaction), findsOneWidget);
      expect(
        find.byKey(OverviewPage.overviewRangeIconKey).hitTestable(),
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

      final icon = find.byKey(OverviewPage.overviewRangeIconKey).hitTestable();
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
            DeleteState(
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
            DeleteState(
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
          'hide FAB when scroll to bottom and show FAB when scroll to top '
          'when tap the FAB should show TransactionCreatePage', (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
        when(overviewBalanceCubit.state)
            .thenReturn(OverviewBalanceState.initial());
        when(overviewTransactionBloc.state).thenReturn(OverviewTransactionState(
            data: [], isReachEnd: false, status: FetchStatus.initial()));
        await tester.pumpWidget(subject);

        final fab = find.byType(FloatingActionButton);

        expect(fab, findsOneWidget);
        // scroll to bottom
        await tester.drag(
          find.byType(OverviewBalance),
          const Offset(0.0, -100.0),
          touchSlopY: 0,
        );
        await tester.pumpAndSettle();
        expect(fab, findsNothing);

        // scroll to top
        await tester.drag(
          find.byType(OverviewBalance),
          const Offset(0.0, 100),
          touchSlopY: 0,
        );
        await tester.pumpAndSettle();
        expect(fab, findsOneWidget);

        await tester.tap(fab.hitTestable());
        await tester.pumpAndSettle();
        expect(find.byType(TransactionCreatePage), findsOneWidget);
      });

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
          find.byKey(OverviewPage.customScrollViewKey),
          Offset(0, -1000),
        );
        verify(
          overviewTransactionBloc.add(OverviewTransactionEvent.fetchMore()),
        ).called(1);
      });
    });
  });
}
