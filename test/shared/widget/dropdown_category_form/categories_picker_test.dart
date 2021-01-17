// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/network/model/model.dart';
import 'package:geldstroom/shared/widget/dropdown_category_form/categories_picker.dart';
import 'package:geldstroom/shared/widget/dropdown_category_form/category_item.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:mockito/mockito.dart';

import '../../../test_helper.dart';

class MockCategoryCubit extends MockBloc<CategoryState>
    implements CategoryCubit {}

final data = <TransactionCategory>[
  TransactionCategory(
    id: '1',
    name: 'Food',
    credit: '',
    iconUrl: 'https://img.url',
  ),
  TransactionCategory(
    id: '2',
    name: 'Sports',
    credit: '',
    iconUrl: 'https://img.url',
  ),
];

void main() {
  group('CategoriesPicker', () {
    CategoryCubit cubit;
    Widget subject;

    final stateInitial = CategoryState();

    final stateSuccess = CategoryState(
      data: data,
      status: FetchStatus.loadSuccess(),
    );

    final stateFailure = CategoryState(
      status: FetchStatus.loadFailure(error: ServerError.networkError()),
    );

    final stateLoadInProgress =
        CategoryState(status: FetchStatus.loadInProgress());

    setUp(() {
      cubit = MockCategoryCubit();
    });

    tearDown(() {
      cubit.close();
    });

    group('renders', () {
      final currectValue = data[0];

      testWidgets(
          'show close icon, search form and a list of category when status is loadSuccess',
          (tester) async {
        when(cubit.state).thenReturn(stateSuccess);
        subject = buildTestableWidget(
          Material(
            child: BlocProvider.value(
              value: cubit,
              child: CategoriesPicker(
                currentValue: currectValue,
                onChange: (v) {},
              ),
            ),
          ),
        );
        await tester.pumpWidget(subject);
        expect(find.byType(CustomTextFormField), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(
          find.byType(CategoryItem),
          findsNWidgets(stateSuccess.data.length),
        );
      });

      testWidgets('show error message when status is loadFailure',
          (tester) async {
        when(cubit.state).thenReturn(stateFailure);
        subject = buildTestableWidget(
          Material(
            child: BlocProvider.value(
              value: cubit,
              child: CategoriesPicker(
                currentValue: data[0],
                onChange: (v) {},
              ),
            ),
          ),
        );
        await tester.pumpWidget(subject);
        expect(find.byType(ErrorMessage), findsOneWidget);
        expect(find.byType(MainButton), findsOneWidget);

        await tester.tap(find.byType(MainButton));
        verify(cubit.fetch()).called(2);
      });

      testWidgets('show loading indicator when status is loadInProgress',
          (tester) async {
        when(cubit.state).thenReturn(stateLoadInProgress);
        subject = buildTestableWidget(
          Material(
            child: BlocProvider.value(
              value: cubit,
              child: CategoriesPicker(
                currentValue: data[0],
                onChange: (v) {},
              ),
            ),
          ),
        );
        await tester.pumpWidget(subject);
        expect(find.byType(LoadingIndicator), findsOneWidget);
      });
    });

    group('functionallity', () {
      testWidgets('able to search category', (tester) async {
        final query = 'food';

        when(cubit.state).thenReturn(stateSuccess);
        subject = buildTestableWidget(
          Material(
            child: BlocProvider.value(
              value: cubit,
              child: CategoriesPicker(
                currentValue: data[0],
                onChange: (v) {},
              ),
            ),
          ),
        );

        await tester.pumpWidget(subject);

        // enter text to search form
        await tester.enterText(find.byType(CustomTextFormField), query);
        await tester.pumpAndSettle();
        expect(find.text(data[0].name), findsOneWidget);
        expect(find.text(data[1].name), findsNothing);
      });

      testWidgets('able to select a category', (tester) async {
        var currentValue = data[0];

        when(cubit.state).thenReturn(stateSuccess);
        subject = buildTestableWidget(
          Material(
            child: BlocProvider.value(
              value: cubit,
              child: CategoriesPicker(
                currentValue: currentValue,
                onChange: (v) {
                  currentValue = v;
                },
              ),
            ),
          ),
        );

        await tester.pumpWidget(subject);
        await tester.tap(find.text(data[1].name).hitTestable());
        await tester.pumpAndSettle();
        await tester.pump(Duration(milliseconds: 500));
        expect(currentValue, data[1]);
      });
    });

    group('initState calls', () {
      testWidgets('fetch when current state status is initial', (tester) async {
        when(cubit.state).thenReturn(stateInitial);
        subject = buildTestableWidget(
          Material(
            child: BlocProvider.value(
              value: cubit,
              child: CategoriesPicker(
                currentValue: data[0],
                onChange: (v) {},
              ),
            ),
          ),
        );
        await tester.pumpWidget(subject);
        verify(cubit.fetch()).called(1);
      });

      testWidgets('fetch when current state status is loadFailure',
          (tester) async {
        when(cubit.state).thenReturn(stateFailure);
        subject = buildTestableWidget(
          Material(
            child: BlocProvider.value(
              value: cubit,
              child: CategoriesPicker(
                currentValue: data[0],
                onChange: (v) {},
              ),
            ),
          ),
        );
        await tester.pumpWidget(subject);
        verify(cubit.fetch()).called(1);
      });

      testWidgets('not fetching when current state status is loadSuccess',
          (tester) async {
        when(cubit.state).thenReturn(stateSuccess);
        subject = buildTestableWidget(
          Material(
            child: BlocProvider.value(
              value: cubit,
              child: CategoriesPicker(
                currentValue: data[0],
                onChange: (v) {},
              ),
            ),
          ),
        );
        await tester.pumpWidget(subject);
        verifyNever(cubit.fetch());
      });
    });
  });
}
