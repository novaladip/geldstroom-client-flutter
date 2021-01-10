import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_ui/ui_bloc.dart';
import 'package:geldstroom/ui/home/widget/overview_range_form.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/hydrated_bloc.dart';
import '../../../test_helper.dart';

class MockOverviewRangeCubit extends MockBloc<OverviewRangeState>
    implements OverviewRangeCubit {}

void main() {
  initHydratedBloc();

  group('OverviewRangeForm', () {
    Widget subject;
    OverviewRangeCubit overviewRangeCubit;

    setUp(() {
      overviewRangeCubit = MockOverviewRangeCubit();
      subject = BlocProvider.value(
        value: overviewRangeCubit,
        child: buildTestableWidget(
          Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                child: Text('Open Form'),
                onPressed: () {
                  showMaterialModalBottomSheet(
                    builder: (_) => Material(
                      child: OverviewRangeForm(),
                    ),
                    context: context,
                  );
                },
              ),
            ),
          ),
        ),
      );
    });

    tearDown(() {
      overviewRangeCubit.close();
    });

    testWidgets('render correctly', (tester) async {
      when(overviewRangeCubit.state).thenReturn(OverviewRangeState.initial());

      await tester.pumpWidget(subject);
      await tester.tap(find.text('Open Form'));
      await tester.pump();

      expect(find.text(OverviewRangeForm.title), findsOneWidget);
      expect(find.text('Range'), findsOneWidget);
      expect(find.text(overviewRangeCubit.state.currentValue), findsOneWidget);

      await tester.tap(find.byKey(OverviewRangeForm.dropdownFormKey));
      await tester.pumpAndSettle();

      for (var option in OverviewRangeForm.option) {
        if (overviewRangeCubit.state.currentValue != option) {
          expect(find.text(option.currentValue), findsOneWidget);
          return;
        }
        expect(
          find.text(overviewRangeCubit.state.currentValue),
          findsNWidgets(2),
        );
      }
    });

    testWidgets('update correctly', (tester) async {
      when(overviewRangeCubit.state).thenReturn(OverviewRangeState.initial());

      await tester.pumpWidget(subject);
      await tester.tap(find.text('Open Form'));
      await tester.pumpAndSettle();

      // open dropdown menu
      await tester.tap(
        find.text(overviewRangeCubit.state.currentValue).hitTestable(),
      );
      await tester.pump();
      // select an item
      await tester.tap(
        find.text(OverviewRangeForm.option[1].currentValue).hitTestable(),
      );
      await tester.pumpAndSettle();

      verify(overviewRangeCubit.onChangeRange(OverviewRangeForm.option[1]))
          .called(1);

      // verify close OverviewRangeForm after selecting an item
      expect(find.byType(OverviewRangeForm), findsNothing);
    });
  });
}
