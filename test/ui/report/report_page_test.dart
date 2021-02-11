import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/balance_report/balance_report_cubit.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/loading_indicator/loading_indicator.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:geldstroom/ui/report/widgets/balance_line_charts.dart';
import 'package:geldstroom/ui/report/widgets/report_filter_form.dart';
import 'package:geldstroom/ui/ui.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mockito/mockito.dart';

import '../../helper_tests/tranasction_json.dart';
import '../../test_helper.dart';

class MockReportFilterCubit extends MockBloc<ReportFilterState>
    implements ReportFilterCubit {}

class MockBalanceReportCubit extends MockBloc<BalanceReportState>
    implements BalanceReportCubit {}

void main() {
  group('ReportPage', () {
    ReportFilterCubit reportFilterCubit;
    BalanceReportCubit balanceReportCubit;
    Widget subject;

    final serverError = ServerError.unknownError();
    final data = BalanceReport.fromJson(TransactionJson.balanceReport);
    final stateInitial = BalanceReportState.initial();
    final stateLoading =
        stateInitial.copyWith(status: FetchStatus.loadInProgress());
    final stateError = stateInitial.copyWith(
        status: FetchStatus.loadFailure(error: serverError));
    final stateLoaded =
        stateInitial.copyWith(status: FetchStatus.loadSuccess(), data: data);

    setUp(() {
      reportFilterCubit = MockReportFilterCubit();
      balanceReportCubit = MockBalanceReportCubit();
      subject = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: reportFilterCubit),
          BlocProvider.value(value: balanceReportCubit),
        ],
        child: buildTestableWidget(ReportPage()),
      );
    });

    tearDown(() {
      reportFilterCubit.close();
      balanceReportCubit.close();
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        when(reportFilterCubit.state).thenReturn(ReportFilterState.initial());
        when(balanceReportCubit.state).thenReturn(stateLoaded);
        await tester.pumpWidget(subject);
        expect(find.text(ReportPage.title), findsOneWidget);
        expect(find.byIcon(Icons.filter_list_outlined), findsOneWidget);
        expect(find.byType(BalanceLineCharts), findsOneWidget);
      });
    });

    group('ReportFilterForm', () {
      String formatDate(DateTime date) => Jiffy(date).format('MM-dd-yyyy');

      group('renders', () {
        testWidgets('correctly', (tester) async {
          final reportFilterState = ReportFilterState.initial();
          when(reportFilterCubit.state).thenReturn(reportFilterState);
          when(balanceReportCubit.state).thenReturn(stateLoaded);
          await tester.pumpWidget(subject);
          await tester
              .tap(find.byIcon(Icons.filter_list_outlined).hitTestable());
          await tester.pumpAndSettle();

          expect(find.byType(ReportFilterForm), findsOneWidget);
          expect(find.text('Select Date Range'), findsOneWidget);
          expect(find.text('Start Date'), findsOneWidget);
          expect(find.text('End Date'), findsOneWidget);
          expect(
              find.text(formatDate(reportFilterState.start)), findsOneWidget);
          expect(find.text(formatDate(reportFilterState.end)), findsOneWidget);
          expect(find.text('Apply'), findsOneWidget);
        });
      });

      group('calls', () {
        testWidgets('should able to pull down to refresh', (tester) async {
          when(balanceReportCubit.state).thenReturn(stateLoaded);
          when(reportFilterCubit.state).thenReturn(ReportFilterState.initial());
          await tester.pumpWidget(subject);

          await tester.drag(
            find.byType(BalanceLineChart),
            const Offset(0.0, 300.0),
            touchSlopY: 100,
          );

          await tester.pumpAndSettle();
          verify(balanceReportCubit.refresh()).called(1);
        });

        testWidgets('should able to change start date and end date',
            (tester) async {
          final reportFilterState = ReportFilterState.initial();
          when(reportFilterCubit.state).thenReturn(reportFilterState);
          when(balanceReportCubit.state).thenReturn(stateLoaded);
          await tester.pumpWidget(subject);
          await tester
              .tap(find.byIcon(Icons.filter_list_outlined).hitTestable());
          await tester.pumpAndSettle();

          final startDateInput = find.byKey(ReportFilterForm.startDateInputKey);
          final endDateInput = find.byKey(ReportFilterForm.endDateInputKey);

          await tester.tap(startDateInput);
          await tester.pumpAndSettle();
          await tester.tap(find.text('${reportFilterState.start.day + 1}'));
          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();
          verify(reportFilterCubit.changeStart(any)).called(1);

          await tester.tap(endDateInput);
          await tester.pumpAndSettle();
          await tester.tap(find.text('${reportFilterState.end.day - 1}'));
          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();
          verify(reportFilterCubit.changeEnd(any)).called(1);
        });

        testWidgets(
            'should call BalanceReportCubit.fetch() when Apply button pressed',
            (tester) async {
          final reportFilterState = ReportFilterState.initial();
          when(reportFilterCubit.state).thenReturn(reportFilterState);
          when(balanceReportCubit.state).thenReturn(stateLoaded);
          await tester.pumpWidget(subject);
          await tester
              .tap(find.byIcon(Icons.filter_list_outlined).hitTestable());
          await tester.pumpAndSettle();
          clearInteractions(balanceReportCubit);

          await tester.tap(find.text('Apply').hitTestable());
          await tester.pumpAndSettle();
          verify(balanceReportCubit.fetch()).called(1);
        });
      });
    });

    group('BalanceLineCharts', () {
      group('renders', () {
        testWidgets(
            'should render LoadingIndicator when state is LoadInProgress',
            (tester) async {
          when(reportFilterCubit.state).thenReturn(ReportFilterState.initial());
          when(balanceReportCubit.state).thenReturn(stateLoading);
          await tester.pumpWidget(subject);
          expect(find.byType(LoadingIndicator), findsOneWidget);
        });

        testWidgets('should render LoadingIndicator when state is Initial',
            (tester) async {
          when(reportFilterCubit.state).thenReturn(ReportFilterState.initial());
          when(balanceReportCubit.state).thenReturn(stateInitial);
          await tester.pumpWidget(subject);
          expect(find.byType(LoadingIndicator), findsOneWidget);
        });

        testWidgets('should render ErrorMessageRetry when state is LoadFailure',
            (tester) async {
          when(reportFilterCubit.state).thenReturn(ReportFilterState.initial());
          when(balanceReportCubit.state).thenReturn(stateError);
          await tester.pumpWidget(subject);
          expect(find.byType(ErrorMessageRetry), findsOneWidget);
          expect(find.text(serverError.message), findsOneWidget);
          expect(find.text('Retry'), findsOneWidget);
          clearInteractions(balanceReportCubit);
          await tester.tap(find.text('Retry').hitTestable());
          verify(balanceReportCubit.fetch()).called(1);
        });

        testWidgets('should render BalanceLineChart when state is LoadSuccess',
            (tester) async {
          when(reportFilterCubit.state).thenReturn(ReportFilterState.initial());
          when(balanceReportCubit.state).thenReturn(stateLoaded);
          await tester.pumpWidget(subject);
          expect(find.byType(BalanceLineChart), findsOneWidget);
        });

        testWidgets(
            // ignore: lines_longer_than_80_chars
            'should render text message when state is LoadSuccess with empty data',
            (tester) async {
          when(reportFilterCubit.state).thenReturn(ReportFilterState.initial());
          when(balanceReportCubit.state).thenReturn(stateLoaded.copyWith(
              data: BalanceReport(expense: [], income: [])));
          await tester.pumpWidget(subject);
          expect(find.text('There is not enough data'), findsOneWidget);
        });
      });

      group('calls', () {
        testWidgets('should call BalanceReportCubit.fetch on init state',
            (tester) async {
          when(reportFilterCubit.state).thenReturn(ReportFilterState.initial());
          when(balanceReportCubit.state).thenReturn(stateInitial);
          await tester.pumpWidget(subject);
          verify(balanceReportCubit.fetch()).called(1);
        });
      });
    });
  });
}
