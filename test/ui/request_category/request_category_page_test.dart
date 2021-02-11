// ignore_for_file: lines_longer_than_80_chars
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/bloc.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/request_category/widgets/request_category_item.dart';
import 'package:geldstroom/ui/ui.dart';
import 'package:mockito/mockito.dart';

import '../../helper_tests/request_category_json.dart';
import '../../test_helper.dart';

class MockRequestCategoryCubit extends MockBloc<RequestCategoryState>
    implements RequestCategoryCubit {}

class MockRequestCategoryDeleteCubit extends MockBloc<DeleteState>
    implements RequestCategoryDeleteCubit {}

void main() {
  group('RequestCategoryPage', () {
    RequestCategoryCubit cubit;
    RequestCategoryDeleteCubit deleteCubit;
    Widget subject;

    final data = RequestCategoryJson.list
        .map((json) => RequestCategory.fromJson(json))
        .toList();
    final serverError = ServerError.networkError();

    // RequestCategoryState
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

    // RequestDeleteState
    final deleteStateInitial = DeleteState.initial();
    final deleteStateLoading =
        deleteStateInitial.copyWith(onDeleteProgressIds: [data[0].id]);
    final deleteStateFailure =
        deleteStateInitial.copyWith(onDeleteFailureIds: [data[0].id]);
    final deleteStateSuccess =
        deleteStateInitial.copyWith(onDeleteSuccessIds: [data[0].id]);

    setUp(() {
      cubit = MockRequestCategoryCubit();
      when(cubit.state).thenReturn(stateLoadSuccess);

      deleteCubit = MockRequestCategoryDeleteCubit();
      when(deleteCubit.state).thenReturn(deleteStateInitial);

      subject = buildTestableBlocWidget(
        routes: {
          RequestCategoryPage.routeName: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: cubit),
                  BlocProvider.value(value: deleteCubit),
                ],
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
      deleteCubit.close();
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

      testWidgets('when delete state there is 1 id in onProgressIds',
          (tester) async {
        when(deleteCubit.state).thenReturn(deleteStateLoading);
        await tester.pumpWidget(subject);
        expect(find.byType(SpinKitChasingDots), findsOneWidget);
      });
    });

    group('listen', () {
      group('listen for DeleteState changes', () {
        testWidgets(
            'should show snackbar when there is a new id in onDeleteSuccessIds',
            (tester) async {
          whenListen(
            deleteCubit,
            Stream.fromIterable([
              deleteStateInitial,
              deleteStateSuccess,
            ]),
          );
          when(deleteCubit.state).thenReturn(deleteStateSuccess);
          await tester.pumpWidget(subject);
          await tester.pump(Duration(seconds: 1));
          expect(
            find.text('Request category has been deleted'),
            findsOneWidget,
          );
        });

        testWidgets(
            'should show snackbar when there is a new id in onDeleteFailureIds',
            (tester) async {
          whenListen(
            deleteCubit,
            Stream.fromIterable([
              deleteStateInitial,
              deleteStateFailure,
            ]),
          );
          when(deleteCubit.state).thenReturn(deleteStateFailure);
          await tester.pumpWidget(subject);
          await tester.pump(Duration(seconds: 1));
          expect(
            find.text('Failed to delete request category'),
            findsOneWidget,
          );
        });
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
        verify(deleteCubit.delete(data[0].id)).called(1);
      });

      testWidgets('should able to tap edit action', (tester) async {
        when(deleteCubit.state).thenReturn(deleteStateInitial);
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
