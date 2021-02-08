import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/request_category/widgets/request_category_item.dart';
import 'package:geldstroom/ui/ui.dart';
import 'package:mockito/mockito.dart';

import '../../helper_tests/request_category_json.dart';
import '../../test_helper.dart';

class MockRequestCategoryCubit extends MockBloc<RequestCategoryState>
    implements RequestCategoryCubit {}

void main() {
  group('RequestCategoryPage', () {
    RequestCategoryCubit cubit;
    Widget subject;

    final data = RequestCategoryJson.list
        .map((json) => RequestCategory.fromJson(json))
        .toList();
    final serverError = ServerError.networkError();
    final stateInitial = RequestCategoryState.initial();
    final stateLoadInProgress =
        stateInitial.copyWith(status: FetchStatus.loadInProgress());
    final stateLoadSuccess = stateInitial.copyWith(
      data: data,
      status: FetchStatus.loadSuccess(),
    );
    final stateLoadSuccessEmpty = stateLoadSuccess.copyWith(data: []);
    final stateLoadFailure = stateInitial.copyWith(
      status: FetchStatus.loadFailure(error: serverError),
    );

    setUp(() {
      cubit = MockRequestCategoryCubit();
      when(cubit.state).thenReturn(stateLoadSuccess);
      subject = buildTestableBlocWidget(
        routes: {
          RequestCategoryPage.routeName: (_) => BlocProvider.value(
                value: cubit,
                child: RequestCategoryPage(),
              ),
          RequestCategoryCreatePage.routeName: (_) =>
              Scaffold(key: Key('request_category_create_page')),
        },
        initialRoutes: RequestCategoryPage.routeName,
      );
    });

    tearDown(() {
      cubit.close();
    });

    group('renders', () {
      testWidgets('when state is load success', (tester) async {
        await tester.pumpWidget(subject);
        expect(find.byType(RequestCategoryItem), findsNWidgets(data.length));
        expect(find.byIcon(Icons.add), findsOneWidget);
      });

      testWidgets('when state is load success with empty data', (tester) async {
        when(cubit.state).thenReturn(stateLoadSuccessEmpty);
        await tester.pumpWidget(subject);
        expect(find.byType(RequestCategoryItem), findsNothing);
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text(RequestCategoryPage.emptyText), findsOneWidget);
      });

      testWidgets('when state is initial', (tester) async {
        when(cubit.state).thenReturn(stateInitial);
        await tester.pumpWidget(subject);
        expect(find.byType(LoadingIndicator), findsOneWidget);
      });

      testWidgets('when state is load in progress', (tester) async {
        when(cubit.state).thenReturn(stateLoadInProgress);
        await tester.pumpWidget(subject);
        expect(find.byType(LoadingIndicator), findsOneWidget);
      });

      testWidgets('when state is load failure', (tester) async {
        when(cubit.state).thenReturn(stateLoadFailure);
        await tester.pumpWidget(subject);
        expect(find.byType(ErrorMessageRetry), findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets('should call RequestCategoryCubit.fetch() on init state',
          (tester) async {
        when(cubit.state).thenReturn(stateInitial);
        await tester.pumpWidget(subject);
        verify(cubit.fetch()).called(1);
      });

      testWidgets('able to navigate to RequestCategoryCreatePage',
          (tester) async {
        when(cubit.state).thenReturn(stateInitial);
        await tester.pumpWidget(subject);
        await tester.tap(find.byIcon(Icons.add).hitTestable());
        await tester.pumpAndSettle();
        expect(find.byKey(Key('request_category_create_page')), findsOneWidget);
      });

      testWidgets('should able to refetch data when load failure',
          (tester) async {
        when(cubit.state).thenReturn(stateLoadFailure);
        await tester.pumpWidget(subject);
        clearInteractions(cubit);
        await tester.tap(find.text(ErrorMessageRetry.retryText).hitTestable());
        verify(cubit.fetch()).called(1);
      });

      testWidgets('should able to tap delete action', (tester) async {
        await tester.pumpWidget(subject);

        final target = find.text(data[0].categoryName);
        expect(target, findsOneWidget);
        // swipe to right
        await tester.drag(target, Offset(500, 0));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete').hitTestable());
        await tester.pumpAndSettle();
        // @TODO
      });

      testWidgets('should able to tap edit action', (tester) async {
        await tester.pumpWidget(subject);

        final target = find.text(data[0].categoryName);
        expect(target, findsOneWidget);
        // swipe to right
        await tester.drag(target, Offset(500, 0));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Edit').hitTestable());
        await tester.pumpAndSettle();
        // @TODO
      });
    });
  });
}
