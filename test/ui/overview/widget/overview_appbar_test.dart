import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/ui/overview/widget/overview_appbar.dart';
import 'package:geldstroom/ui/overview/widget/overview_range_form.dart';
import 'package:mockito/mockito.dart';

import '../../../test_helper.dart';

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

void main() {
  group('OverviewAppBar', () {
    group('renders', () {
      testWidgets('correctly', (tester) async {
        final subject = buildTestableWidget(
          CustomScrollView(
            slivers: [
              OverviewAppBar(),
            ],
          ),
        );
        await tester.pumpWidget(subject);
        expect(find.text(OverviewAppBar.title), findsOneWidget);
        expect(find.byKey(OverviewAppBar.overviewRangeIconKey), findsOneWidget);
      });
    });

    group('calls', () {
      testWidgets(
          'when tapping the overview range icon should open OverviewRangeForm',
          (tester) async {
        final overviewRangeCubit = MockOverviewRangeCubit();
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.monthly());
        final subject = BlocProvider<OverviewRangeCubit>.value(
          value: overviewRangeCubit,
          child: buildTestableBlocWidget(
            routes: {
              '/': (_) => Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        OverviewAppBar(),
                      ],
                    ),
                  ),
            },
            initialRoutes: '/',
          ),
        );

        await tester.pumpWidget(subject);
        await tester.tap(find.byKey(OverviewAppBar.overviewRangeIconKey));
        await tester.pumpAndSettle();
        expect(find.byType(OverviewRangeForm), findsOneWidget);
      });
    });
  });
}
