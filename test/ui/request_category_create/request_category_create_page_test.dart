// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/main_button/main_button.dart';
import 'package:geldstroom/ui/request_category_create/widgets/request_category_create_form.dart';
import 'package:geldstroom/ui/ui.dart';
import 'package:mockito/mockito.dart';

import '../../helper_tests/request_category_json.dart';
import '../../test_helper.dart';

class MockRequestCategoryCreateCubit
    extends MockBloc<FormStatusData<RequestCategory>>
    implements RequestCategoryCreateCubit {}

void main() {
  group('RequestCategoryCreatePage', () {
    RequestCategoryCreateCubit cubit;
    Widget subject;

    final data = RequestCategory.fromJson(RequestCategoryJson.list[0]);
    final serverError = ServerError.unknownError();
    final stateIdle = FormStatusData<RequestCategory>.idle();
    final stateLoading = FormStatusData<RequestCategory>.loading();
    final stateError =
        FormStatusData<RequestCategory>.error(error: serverError);
    final stateSuccess = FormStatusData<RequestCategory>.success(data: data);

    setUp(() {
      cubit = MockRequestCategoryCreateCubit();
      when(cubit.state).thenReturn(stateIdle);
      subject = buildTestableWidget(
        BlocProvider.value(
          value: cubit,
          child: RequestCategoryCreatePage(),
        ),
      );
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        await tester.pumpWidget(subject);

        expect(find.text(RequestCategoryCreatePage.title), findsOneWidget);
        expect(find.text('Category Name'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
        expect(find.text('Submit'), findsOneWidget);
      });

      testWidgets(
          'show loading indicator on submit button '
          'when state loading', (tester) async {
        when(cubit.state).thenReturn(stateLoading);
        await tester.pumpWidget(subject);
        expect(find.text(RequestCategoryCreatePage.title), findsOneWidget);
        expect(find.text('Category Name'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
        expect(find.text('Submit'), findsNothing);
        expect(find.byKey(MainButton.loadingIndicatorKey), findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets('RequestCategoryCreateCubit.clear() on init state',
          (tester) async {
        await tester.pumpWidget(subject);
        verify(cubit.clear()).called(1);
      });

      testWidgets('should able to dismissing the AlertDialog', (tester) async {
        await tester.pumpWidget(subject);

        final dto = RequestCategoryCreateDto(
          name: data.categoryName,
          description: data.categoryName,
        );

        final nameInput = find.byKey(RequestCategoryCreateForm.nameInputKey);
        final descriptionInput =
            find.byKey(RequestCategoryCreateForm.descriptionInputKey);

        await tester.enterText(nameInput, dto.name);
        await tester.enterText(descriptionInput, dto.description);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Submit').hitTestable());
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        await tester.tap(find.text('Cancel').hitTestable());
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets(
          'RequestCategoryCreateCubit.sumbit(dto) when submitting with valid value',
          (tester) async {
        await tester.pumpWidget(subject);

        final dto = RequestCategoryCreateDto(
          name: data.categoryName,
          description: data.categoryName,
        );

        final nameInput = find.byKey(RequestCategoryCreateForm.nameInputKey);
        final descriptionInput =
            find.byKey(RequestCategoryCreateForm.descriptionInputKey);

        await tester.enterText(nameInput, dto.name);
        await tester.enterText(descriptionInput, dto.description);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Submit').hitTestable());
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        await tester.tap(find.text('Confirm').hitTestable());
        verify(cubit.submit(dto)).called(1);
      });

      testWidgets('submitting an invalid value should show error text',
          (tester) async {
        await tester.pumpWidget(subject);
        await tester.tap(find.text('Submit').hitTestable());
        await tester.pumpAndSettle();
        expect(find.text('Category name is cannot be empty'), findsOneWidget);
      });
    });

    group('listen', () {
      testWidgets('listen for error', (tester) async {
        whenListen(
          cubit,
          Stream.fromIterable([
            stateIdle,
            stateLoading,
            stateError,
          ]),
        );
        when(cubit.state).thenReturn(stateError);
        await tester.pumpWidget(subject);
        await tester.pump(Duration(milliseconds: 100));
        expect(find.text(serverError.message), findsOneWidget);
      });

      testWidgets('listen for success', (tester) async {
        whenListen(
          cubit,
          Stream.fromIterable([
            stateIdle,
            stateLoading,
            stateSuccess,
          ]),
        );
        when(cubit.state).thenReturn(stateSuccess);
        await tester.pumpWidget(subject);
        // @TODO
      });

      testWidgets('do nothing when state is not error or success',
          (tester) async {
        whenListen(
          cubit,
          Stream.fromIterable([
            stateIdle,
            stateLoading,
          ]),
        );
        when(cubit.state).thenReturn(stateLoading);
        await tester.pumpWidget(subject);
      });
    });
  });
}
