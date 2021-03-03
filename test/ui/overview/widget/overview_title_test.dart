import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/ui/overview/widget/overview_title.dart';
import 'package:mockito/mockito.dart';

import '../../../test_helper.dart';

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

void main() {
  group('OverviewTitle', () {
    OverviewRangeCubit overviewRangeCubit;
    Widget subject;

    setUp(() {
      overviewRangeCubit = MockOverviewRangeCubit();
      subject = BlocProvider.value(
        value: overviewRangeCubit,
        child: buildTestableWidget(
          CustomScrollView(
            slivers: [
              OverviewTitle(),
            ],
          ),
        ),
      );
    });

    tearDown(() {
      overviewRangeCubit.close();
    });

    group('renders', () {
      testWidgets('correctly when overview range state is monthly',
          (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.monthly());
        await tester.pumpWidget(subject);
        final title = '${OverviewTitle.title} month';
        expect(find.text(title), findsOneWidget);
      });

      testWidgets('correctly when overview range state is weekly',
          (tester) async {
        when(overviewRangeCubit.state).thenReturn(OverviewRangeState.weekly());
        await tester.pumpWidget(subject);
        final title = '${OverviewTitle.title} week';
        expect(find.text(title), findsOneWidget);
      });
    });
  });
}
