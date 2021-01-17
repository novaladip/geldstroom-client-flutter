import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/ui/transaction_edit/transaction_edit_page.dart';
import 'package:geldstroom/ui/transaction_edit/widgets/transaction_edit_form.dart';
import 'package:geldstroom/ui/transaction_edit/widgets/transaction_edit_header.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

class MockCategoryCubit extends MockBloc<CategoryState>
    implements CategoryCubit {}

final data = Transaction(
  id: '1',
  amount: 50000,
  category: TransactionCategory(
    id: '1',
    credit: 'some credit',
    iconUrl: 'https://icon.url',
    name: 'Food',
  ),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  description: '',
  type: 'EXPENSE',
  userId: '1',
);

void main() {
  group('TransactionEditPage', () {
    CategoryCubit categoryCubit;
    Widget subject;

    setUp(() {
      categoryCubit = MockCategoryCubit();
      when(categoryCubit.state).thenReturn(CategoryState());
      subject = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: categoryCubit),
        ],
        child: buildTestableBlocWidget(
          routes: {
            TransactionEditPage.routeName: (_) =>
                TransactionEditPage(data: data),
          },
          initialRoutes: TransactionEditPage.routeName,
        ),
      );
    });

    tearDown(() {
      categoryCubit.close();
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        await tester.pumpWidget(subject);
        expect(find.byType(TransactionEditHeader), findsOneWidget);
        expect(find.byType(TransactionEditForm), findsOneWidget);
      });
    });
  });
}
