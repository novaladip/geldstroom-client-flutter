import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/common/utils/utils.dart';
import 'package:geldstroom/shared/widget/transaction_card/transaction_card.dart';
import 'package:jiffy/jiffy.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_helper.dart';

void main() {
  group('TransactionCard', () {
    final data = Transaction(
      amount: 10000,
      category: TransactionCategory(
        credit: '',
        iconUrl:
            'https://res.cloudinary.com/dwxrp75d0/image/upload/v1602479481/sickfits/gcdxgwj2ddj0fmtxuujm.png',
        id: 'dsadsa',
        name: 'Food',
      ),
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      updatedAt: DateTime.now(),
      description: 'Some',
      id: '12313',
      type: 'EXPENSE',
      userId: '321321',
    );

    final dataWeekAgo = Transaction(
      amount: 10000,
      category: TransactionCategory(
        credit: '',
        iconUrl:
            'https://res.cloudinary.com/dwxrp75d0/image/upload/v1602479481/sickfits/gcdxgwj2ddj0fmtxuujm.png',
        id: 'dsadsa',
        name: 'Food',
      ),
      createdAt: DateTime.now().subtract(Duration(days: 8)),
      updatedAt: DateTime.now(),
      description: 'Some',
      id: '12313',
      type: 'EXPENSE',
      userId: '321321',
    );

    group('renders', () {
      testWidgets('correctly', (tester) async {
        final subject = mockNetworkImagesFor(
          () => buildTestableWidget(
            TransactionCard(
              data: data,
              onDelete: () {},
              onEdit: () {},
            ),
          ),
        );

        await tester.pumpWidget(subject);

        expect(find.text(data.category.name), findsOneWidget);
        expect(find.byType(CachedNetworkImage), findsOneWidget);
        expect(find.text(FormatCurrency.toIDR(data.amount)), findsOneWidget);
        expect(find.text('a day ago'), findsOneWidget);
        expect(find.text('Edit').hitTestable(), findsNothing);
        expect(find.text('Delete').hitTestable(), findsNothing);
      });

      testWidgets('correctly when isDeleting is true', (tester) async {
        final subject = mockNetworkImagesFor(
          () => buildTestableWidget(
            TransactionCard(
              data: data,
              isDeleting: true,
              onDelete: () {},
              onEdit: () {},
            ),
          ),
        );

        await tester.pumpWidget(subject);
        expect(find.byType(SpinKitChasingDots), findsOneWidget);
        expect(find.text(data.category.name), findsOneWidget);
        expect(find.byType(CachedNetworkImage), findsNothing);
        expect(find.text(FormatCurrency.toIDR(data.amount)), findsOneWidget);
        expect(find.text('a day ago'), findsOneWidget);
        expect(find.text('Edit').hitTestable(), findsNothing);
        expect(find.text('Delete').hitTestable(), findsNothing);
      });

      testWidgets('correctly when createdAt is more than a week ago',
          (tester) async {
        final subject = mockNetworkImagesFor(
          () => buildTestableWidget(
            TransactionCard(
              data: dataWeekAgo,
              onDelete: () {},
              onEdit: () {},
            ),
          ),
        );

        await tester.pumpWidget(subject);

        expect(find.text(data.category.name), findsOneWidget);
        expect(find.byType(CachedNetworkImage), findsOneWidget);
        expect(find.text(FormatCurrency.toIDR(data.amount)), findsOneWidget);
        expect(find.text(Jiffy(dataWeekAgo.createdAt).format('MM/DD/yyyy')),
            findsOneWidget);
        expect(find.text('Edit').hitTestable(), findsNothing);
        expect(find.text('Delete').hitTestable(), findsNothing);
      });

      testWidgets('should show slide action after swiping to right direction',
          (tester) async {
        final key = UniqueKey();
        final subject = buildTestableWidget(
          TransactionCard(
            key: key,
            data: data,
            onDelete: () {},
            onEdit: () {},
          ),
        );

        await tester.pumpWidget(subject);
        expect(find.byKey(key), findsOneWidget);

        expect(find.text('Edit').hitTestable(), findsNothing);
        expect(find.text('Delete').hitTestable(), findsNothing);

        // swipe to right
        await tester.drag(find.byKey(key), Offset(500, 0));
        await tester.pumpAndSettle();
        expect(find.text('Edit').hitTestable(), findsOneWidget);
        expect(find.text('Delete').hitTestable(), findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets('onEdit should call given callback', (tester) async {
        var edit = false;
        final key = UniqueKey();
        final subject = buildTestableWidget(
          TransactionCard(
            key: key,
            data: data,
            onDelete: () {},
            onEdit: () {
              edit = true;
            },
          ),
        );

        await tester.pumpWidget(subject);
        expect(find.byKey(key), findsOneWidget);

        expect(edit, false);

        // swipe to right
        await tester.drag(find.byKey(key), Offset(500, 0));
        await tester.pumpAndSettle();
        expect(find.text('Edit').hitTestable(), findsOneWidget);
        expect(find.text('Delete').hitTestable(), findsOneWidget);

        await tester.tap(find.text('Edit'));
        expect(edit, true);
      });
      testWidgets('onDelete should call given callback', (tester) async {
        var delete = false;
        final key = UniqueKey();
        final subject = buildTestableWidget(
          TransactionCard(
            key: key,
            data: data,
            onDelete: () {
              delete = true;
            },
            onEdit: () {},
          ),
        );

        await tester.pumpWidget(subject);
        expect(find.byKey(key), findsOneWidget);
        expect(delete, false);

        // swipe to right
        await tester.drag(find.byKey(key), Offset(500, 0));
        await tester.pumpAndSettle();
        expect(find.text('Edit').hitTestable(), findsOneWidget);
        expect(find.text('Delete').hitTestable(), findsOneWidget);

        await tester.tap(find.text('Delete'));
        expect(delete, true);
      });
    });
  });
}
