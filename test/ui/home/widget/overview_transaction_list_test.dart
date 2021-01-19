import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/transaction_card/transaction_card.dart';
import 'package:geldstroom/ui/home/widget/overview_transaction_list.dart';
import 'package:geldstroom/ui/transaction_edit/transaction_edit_page.dart';
import 'package:mockito/mockito.dart';
import 'package:geldstroom/core/bloc/overview_transaction/overview_transaction_bloc.dart';

import '../../../test_helper.dart';

class MockOverviewTransctionBloc extends MockBloc<OverviewTransactionState>
    implements OverviewTransactionBloc {}

class MockTransactionEditCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionEditCubit {}

class MockTransactionDeleteCubit extends MockBloc<TransactionDeleteState>
    implements TransactionDeleteCubit {}

class MockCategoryCubit extends MockBloc<CategoryState>
    implements CategoryCubit {}

void main() {
  group('OverviewTransactionList', () {
    Widget subject;
    OverviewTransactionBloc overviewTransactionBloc;
    CategoryCubit categoryCubit;
    TransactionEditCubit transactionEditCubit;
    TransactionDeleteCubit transactionDeleteCubit;
    final transaction = Transaction(
      id: '231321',
      amount: 32222,
      category: TransactionCategory(
        credit: '',
        iconUrl: 'https://images.com',
        id: '',
        name: 'Food',
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      description: '',
      type: 'INCOME',
      userId: '321321',
    );
    final data = <Transaction>[transaction];

    setUp(() {
      overviewTransactionBloc = MockOverviewTransctionBloc();
      categoryCubit = MockCategoryCubit();
      transactionEditCubit = MockTransactionEditCubit();
      transactionDeleteCubit = MockTransactionDeleteCubit();
      when(categoryCubit.state).thenReturn(CategoryState());
      when(transactionEditCubit.state).thenReturn(FormStatusData.idle());
      when(transactionDeleteCubit.state)
          .thenReturn(TransactionDeleteState.initial());
      when(overviewTransactionBloc.state).thenReturn(
        OverviewTransactionState(
          data: data,
          isReachEnd: true,
          status: FetchStatus.loadSuccess(),
        ),
      );

      subject = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: overviewTransactionBloc),
          BlocProvider.value(value: categoryCubit),
          BlocProvider.value(value: transactionEditCubit),
          BlocProvider.value(value: transactionDeleteCubit),
        ],
        child: buildTestableBlocWidget(
          initialRoutes: '/',
          routes: {
            '/': (_) => Scaffold(
                  body: CustomScrollView(
                    slivers: [OverviewTransactionList()],
                  ),
                ),
          },
        ),
      );
    });
    group('renders', () {
      testWidgets('correctly', (tester) async {
        await tester.pumpWidget(subject);
        expect(find.byType(TransactionCard), findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets('tap Edit action', (tester) async {
        await tester.pumpWidget(subject);
        // swipe to right
        await tester.drag(find.text(transaction.category.name), Offset(500, 0));
        await tester.pumpAndSettle();
        final editButton = find.text('Edit').hitTestable();
        await tester.tap(editButton);
        await tester.pumpAndSettle();
        expect(editButton.hitTestable(), findsNothing);
        expect(find.byType(TransactionEditPage), findsOneWidget);
      });

      testWidgets('tap Delete action', (tester) async {
        await tester.pumpWidget(subject);
        // swipe to right
        await tester.drag(find.text(transaction.category.name), Offset(500, 0));
        await tester.pumpAndSettle();
        final deleteButton = find.text('Delete').hitTestable();
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();
        expect(deleteButton.hitTestable(), findsNothing);
        verify(transactionDeleteCubit.delete(transaction.id)).called(1);
      });
    });
  });
}
