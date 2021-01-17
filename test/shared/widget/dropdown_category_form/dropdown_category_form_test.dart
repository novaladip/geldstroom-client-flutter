import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:geldstroom/shared/widget/dropdown_category_form/categories_picker.dart';
import 'package:geldstroom/shared/widget/dropdown_category_form/category_item.dart';
import 'package:geldstroom/shared/widget/dropdown_category_form/dropdown_category_form.dart';
import 'package:geldstroom/shared/widget/widget.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_helper.dart';

class MockCategoryCubit extends MockBloc<CategoryState>
    implements CategoryCubit {}

class Subject extends StatelessWidget {
  final CategoryCubit cubit;
  final TransactionCategory currentValue;
  final Function(TransactionCategory) onChange;

  Subject({
    @required this.cubit,
    @required this.currentValue,
    @required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => cubit,
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: WidgetWrapper(
                DropdownCategoryForm(
                  currentValue: currentValue,
                  onChange: onChange,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  group('CategoryDropdownForm', () {
    CategoryCubit cubit;

    setUp(() {
      cubit = MockCategoryCubit();
    });

    tearDown(() {
      cubit.close();
    });

    group('renders', () {
      testWidgets('correctly', (tester) async {
        final data = <TransactionCategory>[
          TransactionCategory(
            id: '1',
            name: 'Food',
            credit: '',
            iconUrl: 'https://img.url',
          ),
          TransactionCategory(
            id: '2',
            name: 'Food 2',
            credit: '',
            iconUrl: 'https://img.url',
          ),
        ];
        var selectedValue = data[0];

        when(cubit.state).thenReturn(
          CategoryState(
            data: data,
            status: FetchStatus.loadSuccess(),
          ),
        );
        await tester.pumpWidget(
          mockNetworkImagesFor(
            () => Subject(
              cubit: cubit,
              currentValue: selectedValue,
              onChange: (v) {
                selectedValue = v;
              },
            ),
          ),
        );

        expect(find.text('Category'), findsOneWidget);
        expect(find.text(selectedValue.name), findsOneWidget);

        // open bottomshet category option
        await tester.tap(find.byType(DropdownCategoryForm));
        await tester.pumpAndSettle();

        expect(find.byType(CategoriesPicker), findsOneWidget);
        expect(find.byType(CategoryItem), findsNWidgets(data.length));
        expect(find.byType(CustomTextFormField), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);

        await tester.tap(find.text(data[1].name));
        await tester.pumpAndSettle();

        expect(find.byType(CategoriesPicker), findsNothing);
        expect(find.byType(CategoryItem), findsNothing);
        expect(selectedValue, data[1]);
      });
    });
  });
}
