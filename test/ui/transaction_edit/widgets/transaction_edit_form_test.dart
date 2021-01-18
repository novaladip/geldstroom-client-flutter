import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/bloc/transaction_edit/transaction_edit_cubit.dart';
import 'package:geldstroom/core/network/model/transaction_model.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/common/utils/utils.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/transaction_edit/widgets/transaction_edit_form.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_helper.dart';

class MockTransactionEditCubit extends MockBloc<FormStatusData<Transaction>>
    implements TransactionEditCubit {}

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
final categories = <TransactionCategory>[
  TransactionCategory(
    id: '1',
    credit: 'some credit',
    iconUrl: 'https://icon.url',
    name: 'Food',
  ),
  TransactionCategory(
    id: '2',
    credit: 'some credit',
    iconUrl: 'https://icon.url',
    name: 'Pet',
  ),
];

void main() {
  group('TransactionEditForm', () {
    TransactionEditCubit transactionEditCubit;
    CategoryCubit categoryCubit;
    Widget subject;

    final stateIdle = FormStatusData<Transaction>.idle();
    final stateLoading = FormStatusData<Transaction>.loading();

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
            '/': (_) => mockNetworkImagesFor(
                  () => TransactionEditForm(data: data),
                ),
          },
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

        expect(find.text('Description'), findsOneWidget);
        expect(find.text('Amount'), findsOneWidget);
        expect(find.text('Type'), findsOneWidget);
        expect(find.text('Category'), findsOneWidget);
        expect(
          find.text(TransactionEditForm.submitButtonTitle),
          findsOneWidget,
        );

        // find initial form value
        expect(find.text(data.description), findsOneWidget);
        expect(
            find.text(FormatCurrency.toIDR(data.amount).replaceAll('IDR', '')),
            findsOneWidget);
        expect(
          find.text(
            data.type[0].toUpperCase() + data.type.substring(1).toLowerCase(),
          ),
          findsOneWidget,
        );
        expect(find.text(data.category.name), findsOneWidget);
      });

      testWidgets('when status loading', (tester) async {
        when(transactionEditCubit.state).thenReturn(stateLoading);
        await tester.pumpWidget(subject);
        final submitButton = find.byKey(MainButton.loadingIndicatorKey);
        expect(submitButton, findsOneWidget);
        await tester.tap(submitButton);
        verifyNever(transactionEditCubit.submit(any));
      });
    });

    group('functionallity', () {
      testWidgets('change description value', (tester) async {
        await tester.pumpWidget(subject);
        final expectedDescription = 'lorem ipsum';
        final descriptionForm = find.text(data.description).hitTestable();
        await tester.enterText(descriptionForm, expectedDescription);
        await tester.pump();
        // verify description is changed
        expect(find.text(expectedDescription), findsOneWidget);
      });

      testWidgets('change amount value', (tester) async {
        await tester.pumpWidget(subject);
        final expectedAmount = 123456;
        final amountForm = find
            .text(FormatCurrency.toIDR(data.amount).replaceAll('IDR', ''))
            .hitTestable();
        await tester.enterText(amountForm, expectedAmount.toString());
        await tester.pump();
        // verify description is changed
        expect(
            find.text(
                FormatCurrency.toIDR(expectedAmount).replaceAll('IDR', '')),
            findsOneWidget);
      });

      testWidgets('change type value', (tester) async {
        await tester.pumpWidget(subject);
        final expectedType = 'INCOME';
        final typeDropdown = find
            .text(data.type[0].toUpperCase() +
                data.type.substring(1).toLowerCase())
            .hitTestable();
        await tester.tap(typeDropdown);
        await tester.pump();
        await tester.tap(find.text('Income').hitTestable());
        await tester.pumpAndSettle();

        // verify type is changed
        expect(
            find.text(expectedType[0].toUpperCase() +
                expectedType.substring(1).toLowerCase()),
            findsOneWidget);
      });

      testWidgets('change category value', (tester) async {
        when(categoryCubit.state).thenReturn(
          CategoryState(data: categories, status: FetchStatus.loadSuccess()),
        );
        await tester.pumpWidget(subject);
        final expectedCategoryName = categories[1].name;
        final categoryDropdownForm =
            find.text(data.category.name).hitTestable();
        await tester.tap(categoryDropdownForm);
        await tester.pumpAndSettle();
        await tester.tap(find.text(expectedCategoryName).hitTestable());
        await tester.pumpAndSettle();

        // verify type is changed
        expect(find.text(expectedCategoryName), findsOneWidget);
      });

      testWidgets('submitting invalid value, should show error text',
          (tester) async {
        await tester.pumpWidget(subject);
        final invalidAmount = 0;
        final amountForm = find
            .text(FormatCurrency.toIDR(data.amount).replaceAll('IDR', ''))
            .hitTestable();
        await tester.enterText(amountForm, invalidAmount.toString());
        await tester.pump();

        await tester.tap(find.byType(MainButton).hitTestable());
        await tester.pump();
        expect(find.text('Amount must be greater than 0'), findsOneWidget);
      });

      testWidgets('submitting valid value', (tester) async {
        await tester.pumpWidget(subject);
        final newAmount = 10000;
        final amountForm = find
            .text(FormatCurrency.toIDR(data.amount).replaceAll('IDR', ''))
            .hitTestable();
        await tester.enterText(amountForm, newAmount.toString());
        await tester.pump();

        await tester.tap(find.byType(MainButton).hitTestable());
        await tester.pump();
        final dto = TransactionEditDto(
          id: data.id,
          amount: newAmount,
          description: data.description,
          categoryId: data.category.id,
          type: data.type,
        );
        verify(transactionEditCubit.submit(dto)).called(1);
      });
    });
  });
}
