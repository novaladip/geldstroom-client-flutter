import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/credit/credit_page.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../test_helper.dart';

class MockCategoryCubit extends MockBloc<CategoryState>
    implements CategoryCubit {}

void main() {
  group('CreditPage', () {
    CategoryCubit cubit;
    Widget subject;

    final serverError = ServerError.unknownError();
    final categories = <TransactionCategory>[
      TransactionCategory(
        id: '321-321',
        name: 'Food',
        credit: 'Made by somebody from',
        iconUrl: 'https://img.url',
      )
    ];
    final stateInitial = CategoryState();
    final stateLoading =
        stateInitial.copyWith(status: FetchStatus.loadInProgress());
    final stateFailure = stateInitial.copyWith(
        status: FetchStatus.loadFailure(error: serverError));
    final stateSuccess = stateInitial.copyWith(
        data: categories, status: FetchStatus.loadSuccess());

    setUp(() {
      cubit = MockCategoryCubit();
      when(cubit.state).thenReturn(stateInitial);
      subject = mockNetworkImagesFor(
        () => buildTestableWidget(
          BlocProvider.value(value: cubit, child: CreditPage()),
        ),
      );
    });

    tearDown(() {
      cubit.close();
    });

    group('renders', () {
      testWidgets('correctly when load success', (tester) async {
        when(cubit.state).thenReturn(stateSuccess);
        await tester.pumpWidget(subject);
        expect(find.byType(CachedNetworkImage), findsOneWidget);
        expect(find.text(categories[0].credit), findsOneWidget);
      });

      testWidgets('correctly when load failure', (tester) async {
        when(cubit.state).thenReturn(stateFailure);
        await tester.pumpWidget(subject);
        expect(find.byType(ErrorMessageRetry), findsOneWidget);
      });

      testWidgets('correctly when load in progress', (tester) async {
        when(cubit.state).thenReturn(stateLoading);
        await tester.pumpWidget(subject);
        expect(find.byType(LoadingIndicator), findsOneWidget);
      });
    });

    group('calls', () {
      // @TODO
      // open an url from credit text

      testWidgets('when state is not load success, call fetch on init state',
          (tester) async {
        when(cubit.state).thenReturn(stateInitial);
        await tester.pumpWidget(subject);
        verify(cubit.fetch()).called(1);
      });

      testWidgets('when state is load success, dont call fetch on init state',
          (tester) async {
        when(cubit.state).thenReturn(stateSuccess);
        await tester.pumpWidget(subject);
        verifyNever(cubit.fetch());
      });
    });
  });
}
