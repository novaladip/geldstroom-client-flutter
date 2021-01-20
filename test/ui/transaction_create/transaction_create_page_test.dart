import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/bloc/transaction_create/transaction_create_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/common/utils/utils.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/transaction_create/transaction_create_page.dart';
import 'package:geldstroom/ui/transaction_create/widgets/transaction_create_form.dart';
import 'package:geldstroom/ui/transaction_create/widgets/transaction_create_header.dart';
import 'package:mockito/mockito.dart';

import '../../core/network/service/transaction/json.dart';
import '../../test_helper.dart';
import '../overview/widget/overview_transaction_list_test.dart';

class MockTransactionCreateCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionCreateCubit {}

class MockTransactionCategoryCubit extends MockBloc<CategoryState>
    implements CategoryCubit {}

void main() {
  group('TransactionCreatePage', () {
    TransactionCreateCubit transactionCreateCubit;
    CategoryCubit categoryCubit;
    Widget subject;

    final transaction = Transaction.fromJson(getTransactionJson[0]);
    final serverError = ServerError.networkError();
    final stateIdle = FormStatusData<Transaction>.idle();
    final stateLoading = FormStatusData<Transaction>.loading();
    final stateError = FormStatusData<Transaction>.error(error: serverError);
    final stateSuccess = FormStatusData<Transaction>.success(data: transaction);
    final categoryState = CategoryState(
      data: [
        TransactionCategory.fromJson(transaction.category.toJson),
        TransactionCategory.fromJson(getTransactionJson[1]['category']),
      ],
      status: FetchStatus.loadSuccess(),
    );

    setUp(() {
      transactionCreateCubit = MockTransactionCreateCubit();
      categoryCubit = MockCategoryCubit();
      when(transactionCreateCubit.state).thenReturn(stateIdle);
      when(categoryCubit.state).thenReturn(categoryState);
      subject = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: categoryCubit),
          BlocProvider.value(value: transactionCreateCubit),
        ],
        child: buildTestableBlocWidget(
          routes: {
            '/': (_) => TransactionCreatePage(),
          },
        ),
      );
    });

    tearDown(() {
      transactionCreateCubit.close();
      categoryCubit.close();
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        await tester.pumpWidget(subject);

        // header
        expect(find.text(TransactionCreateHeader.title), findsOneWidget);

        // form
        expect(
          find.text(TransactionCreateForm.submitButtonTitle),
          findsOneWidget,
        );
        expect(find.text('Description'), findsOneWidget);
        expect(find.text('Amount'), findsOneWidget);
        expect(find.text('Type'), findsOneWidget);
        expect(find.text('Category'), findsOneWidget);
      });

      testWidgets(
          'when state is loading submit button should show loading indicator',
          (tester) async {
        when(transactionCreateCubit.state).thenReturn(stateLoading);
        await tester.pumpWidget(subject);
        expect(
          find.text(TransactionCreateForm.submitButtonTitle),
          findsNothing,
        );
        expect(find.byKey(MainButton.loadingIndicatorKey), findsOneWidget);
      });
    });

    group('form functionallity', () {
      testWidgets('submitting an empty value should show error text',
          (tester) async {
        when(categoryCubit.state).thenReturn(CategoryState());
        await tester.pumpWidget(subject);
        await tester.tap(
          find.text(TransactionCreateForm.submitButtonTitle).hitTestable(),
        );

        await tester.pumpAndSettle();
        expect(find.text('Amount is cannot be empty'), findsOneWidget);
        expect(find.text('Category is cannot be empty'), findsOneWidget);
      });

      testWidgets('should able to change form value and submit',
          (tester) async {
        final dto = TransactionCreateDto(
          amount: 15000,
          categoryId: categoryState.data[1].id,
          description: 'jual gado-gado',
          type: 'INCOME',
        );

        await tester.pumpWidget(subject);
        await tester.enterText(
          find.byKey(TransactionCreateForm.descriptionFormKey),
          dto.description,
        );
        await tester.enterText(
          find.byKey(TransactionCreateForm.amountFormKey),
          dto.amount.toString(),
        );

        await tester.tap(find.byKey(TransactionCreateForm.typeFormKey));
        await tester.pump();
        await tester.tap(find.text('Income').hitTestable());
        await tester.pump();

        await tester.tap(
            find.byKey(TransactionCreateForm.categoryFormKey).hitTestable());
        await tester.pumpAndSettle();
        await tester.tap(find.text(categoryState.data[1].name).hitTestable());
        await tester.pumpAndSettle();

        expect(
          find.text(FormatCurrency.toIDR(dto.amount).replaceAll('IDR', '')),
          findsOneWidget,
        );
        expect(find.text(dto.description), findsOneWidget);
        expect(
          find.text(
            dto.type[0] + dto.type.substring(1).toLowerCase(),
          ),
          findsOneWidget,
        );
        expect(find.text(categoryState.data[1].name), findsOneWidget);

        await tester.tap(find.text(TransactionCreateForm.submitButtonTitle));
        verify(transactionCreateCubit.submit(dto)).called(1);
      });
    });

    group('listen for TransactionCreateState', () {
      testWidgets('when error should show snackbar', (tester) async {
        whenListen(
          transactionCreateCubit,
          Stream.fromIterable([stateIdle, stateLoading, stateError]),
        );
        await tester.pumpWidget(subject);
        await tester.pumpAndSettle();
        expect(find.text(serverError.message), findsOneWidget);
      });

      testWidgets('when success should pop the page', (tester) async {
        whenListen(
          transactionCreateCubit,
          Stream.fromIterable([stateIdle, stateLoading, stateSuccess]),
        );
        await tester.pumpWidget(subject);
        await tester.pumpAndSettle();

        // @TODO
      });
    });
  });
}
