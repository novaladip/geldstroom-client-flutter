import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/bloc/transaction_edit/transaction_edit_cubit.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/ui/transaction_edit/transaction_edit_page.dart';
import 'package:geldstroom/ui/transaction_edit/widgets/transaction_edit_form.dart';
import 'package:geldstroom/ui/transaction_edit/widgets/transaction_edit_header.dart';
import 'package:mockito/mockito.dart';

import '../../test_helper.dart';

class MockCategoryCubit extends MockBloc<CategoryState>
    implements CategoryCubit {}

class MockTransactionEditCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionEditCubit {}

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
    TransactionEditCubit transactionEditCubit;
    CategoryCubit categoryCubit;
    Widget subject;

    final stateIdle = FormStatusData<Transaction>.idle();
    final stateError =
        FormStatusData<Transaction>.error(error: ServerError.networkError());
    final stateSuccess = FormStatusData<Transaction>.success(data: data);

    setUp(() {
      transactionEditCubit = MockTransactionEditCubit();
      categoryCubit = MockCategoryCubit();

      when(transactionEditCubit.state).thenReturn(stateIdle);
      when(categoryCubit.state).thenReturn(CategoryState());
      subject = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: categoryCubit),
          BlocProvider.value(value: transactionEditCubit),
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
      transactionEditCubit.close();
      categoryCubit.close();
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        await tester.pumpWidget(subject);
        expect(find.byType(TransactionEditHeader), findsOneWidget);
        expect(find.byType(TransactionEditForm), findsOneWidget);
      });
    });

    group('listen', () {
      testWidgets('when status error should show snackbar with error message',
          (tester) async {
        whenListen(
          transactionEditCubit,
          Stream.fromIterable([stateIdle, stateError]),
        );
        when(transactionEditCubit.state).thenReturn(stateError);
        await tester.pumpWidget(subject);
        await tester.pump();
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(ServerError.networkError().message), findsOneWidget);
      });

      testWidgets('when status success should pop the current page',
          (tester) async {
        whenListen(
          transactionEditCubit,
          Stream.fromIterable([stateIdle, stateSuccess]),
        );
        when(transactionEditCubit.state).thenReturn(stateError);
        await tester.pumpWidget(subject);
        await tester.pump();
      });
    });
  });
}
