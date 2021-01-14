import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/transaction_card/transaction_card.dart';
import 'package:geldstroom/ui/home/widget/overview_transaction_list.dart';
import 'package:mockito/mockito.dart';
import 'package:geldstroom/core/bloc/overview_transaction/overview_transaction_bloc.dart';

import '../../../test_helper.dart';

class MockOverviewTransctionBloc extends MockBloc<OverviewTransactionState>
    implements OverviewTransactionBloc {}

void main() {
  group('OverviewTransactionList', () {
    Widget subject;
    OverviewTransactionBloc overviewTransactionBloc;
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
      type: 'Income',
      userId: '321321',
    );
    final data = <Transaction>[transaction];

    setUp(() {
      overviewTransactionBloc = MockOverviewTransctionBloc();
      when(overviewTransactionBloc.state).thenReturn(
        OverviewTransactionState(
          data: data,
          isReachEnd: true,
          status: FetchStatus.loadSuccess(),
        ),
      );
      subject = buildTestableWidget(
        BlocProvider.value(
          value: overviewTransactionBloc,
          child: CustomScrollView(
            slivers: [
              OverviewTransactionList(),
            ],
          ),
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
      });
    });
  });
}
