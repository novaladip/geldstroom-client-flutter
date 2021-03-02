import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/credit/credit_page.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helper_tests/finder.dart';
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
        credit: 'https://google.com',
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
        expect(
          find.byWidgetPredicate((widget) =>
              fromRichTextToPlainText(widget, categories[0].credit)),
          findsOneWidget,
        );
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
      group('open a link in credit text', () {
        const channel = MethodChannel('plugins.flutter.io/url_launcher');
        final log = <MethodCall>[];

        setUp(() {
          channel.setMockMethodCallHandler((mc) async {
            if (mc.method == 'canLaunch') {
              return true;
            }
            log.add(mc);
          });
        });

        tearDown(() {
          channel.setMockMethodCallHandler(null);
        });

        testWidgets('when press the link text should call launchUrl',
            (tester) async {
          when(cubit.state).thenReturn(stateSuccess);
          await tester.pumpWidget(subject);

          final linkTextFinder = find.byWidgetPredicate((widget) =>
              fromRichTextToPlainText(widget, categories[0].credit));

          await tester.tap(linkTextFinder.hitTestable());
          final methocCall = log[0];
          expect(methocCall.method, 'launch');
          expect(methocCall.arguments['url'], categories[0].credit);
        });
      });

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
