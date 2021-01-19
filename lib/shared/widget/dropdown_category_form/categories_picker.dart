import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/bloc/category/category_cubit.dart';
import '../../../core/network/network.dart';
import '../../common/config/config.dart';
import '../widget.dart';
import 'category_item.dart';
import 'dropdown_category_form.dart';

class CategoriesPicker extends StatefulWidget {
  const CategoriesPicker({
    Key key,
    @required this.onChange,
    @required this.currentValue,
  }) : super(key: key);

  final OnChange onChange;
  final TransactionCategory currentValue;

  @override
  _CategoriesPickerState createState() => _CategoriesPickerState();
}

class _CategoriesPickerState extends State<CategoriesPicker> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final status = context.select<CategoryCubit, FetchStatus>(
      (cubit) => cubit.state.status,
    );
    final categories = context.select<CategoryCubit, List<TransactionCategory>>(
      (cubit) => cubit.state.filter(query),
    );

    return <Widget>[
      Icon(Icons.close)
          .iconColor(Colors.white)
          .iconSize(64.sp)
          .alignment(Alignment.topLeft)
          .gestures(onTap: handleClose)
          .padding(bottom: 20.h),
      CustomTextFormField(
        labelText: 'Search Category',
        onChanged: onChangeQuery,
      ).padding(bottom: 20.h),
      // body
      status
          .maybeWhen(
            loadFailure: (e) => <Widget>[
              ErrorMessage(message: e.message),
              SizedBox(height: 13.h),
              MainButton(title: 'Retry', onTap: fetch),
            ].toColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
            ),
            loadInProgress: () => LoadingIndicator(),
            orElse: () => ScrollablePositionedList.builder(
              initialScrollIndex: findSelectedIndex(categories),
              itemCount: categories.length,
              physics: AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemBuilder: (context, index) => CategoryItem(
                data: categories[index],
                isSelected: isSelected(categories[index]),
                onTap: () => onSelect(categories[index]),
              ),
            ),
          )
          .expanded(),
    ]
        .toColumn(mainAxisSize: MainAxisSize.max)
        .padding(horizontal: AppStyles.defaultPaddingHorizontal)
        .parent(({child}) => SafeArea(child: child))
        .backgroundColor(AppStyles.appBarColor);
  }

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().state.status.maybeWhen<void>(
          initial: fetch,
          loadFailure: (e) => fetch(),
          orElse: () {},
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetch() {
    context.read<CategoryCubit>().fetch();
  }

  void onChangeQuery(String value) => setState(() => query = value);

  bool isSelected(TransactionCategory category) {
    if (widget.currentValue == null) return false;
    return category.id == widget.currentValue.id;
  }

  int findSelectedIndex(List<TransactionCategory> categories) {
    if (widget.currentValue == null) return 0;

    final selectedIndex = categories
        .indexWhere((category) => category.id == widget.currentValue.id);
    if (selectedIndex == -1) return 0;
    return selectedIndex;
  }

  void handleClose() {
    Navigator.of(context).pop();
  }

  void onSelect(TransactionCategory category) {
    widget.onChange(category);
    handleClose();
  }
}
