import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/ui/request_category/widgets/request_category_item.dart';
import 'package:jiffy/jiffy.dart';

import '../../../helper_tests/request_category_json.dart';
import '../../../test_helper.dart';

void main() {
  group('RequestCategoryItem', () {
    final data = RequestCategory.fromJson(RequestCategoryJson.list[0]);
    group('renders', () {
      testWidgets('correctly', (tester) async {
        final subject = buildTestableWidget(
          Center(
            child: RequestCategoryItem(
              data: data,
              isDeleting: false,
              isLast: false,
              onDelete: () {},
              onEdit: () {},
            ),
          ),
        );
        await tester.pumpWidget(subject);

        expect(find.text(data.categoryName), findsOneWidget);
        expect(find.text(data.status.replaceAll('_', '')), findsOneWidget);
        expect(find.text(Jiffy(data.updatedAt).format('mm/dd/yyyy hh:mm')),
            findsOneWidget);
      });

      testWidgets('show loading indicator when isDeleting is true',
          (tester) async {
        final subject = buildTestableWidget(
          Center(
            child: RequestCategoryItem(
              data: data,
              isDeleting: true,
              isLast: false,
              onDelete: () {},
              onEdit: () {},
            ),
          ),
        );
        await tester.pumpWidget(subject);
        expect(find.byType(SpinKitChasingDots), findsOneWidget);
      });
    });

    group('calls', () {
      var deleted = false;
      var edited = false;

      final subject = buildTestableWidget(
        Center(
          child: RequestCategoryItem(
            data: data,
            isDeleting: false,
            isLast: false,
            onDelete: () {
              deleted = true;
            },
            onEdit: () {
              edited = true;
            },
          ),
        ),
      );

      testWidgets('should able to tap delete action', (tester) async {
        await tester.pumpWidget(subject);

        final target = find.byType(RequestCategoryItem);
        expect(target, findsOneWidget);
        // swipe to right
        await tester.drag(target, Offset(500, 0));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete').hitTestable());
        await tester.pumpAndSettle();
        expect(deleted, true);
      });

      testWidgets('should able to tap edit action', (tester) async {
        await tester.pumpWidget(subject);

        final target = find.byType(RequestCategoryItem);
        expect(target, findsOneWidget);
        // swipe to right
        await tester.drag(target, Offset(500, 0));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Edit').hitTestable());
        await tester.pumpAndSettle();
        expect(edited, true);
      });
    });
  });
}
