import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/network/model/model.dart';
import '../../common/config/config.dart';
import '../../common/styles/styles.dart';
import 'categories_picker.dart';

typedef OnChange = void Function(TransactionCategory value);

class DropdownCategoryForm extends StatelessWidget {
  const DropdownCategoryForm({
    Key key,
    @required this.currentValue,
    @required this.onChange,
    this.errorText,
  }) : super(key: key);

  final TransactionCategory currentValue;
  final String errorText;
  final OnChange onChange;

  void showOptions(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      useRootNavigator: true,
      expand: true,
      builder: (_) => CategoriesPicker(
        onChange: onChange,
        currentValue: currentValue,
      ),
    );
  }

  Widget get child {
    if (currentValue == null) {
      return Text('Select Category')
          .fontFamily(AppStyles.fontFamilyBody)
          .fontSize(30.sp)
          .textColor(Colors.grey);
    }

    return <Widget>[
      CachedNetworkImage(
        imageUrl: currentValue.iconUrl,
        height: 26.h,
      ),
      SizedBox(width: 10.w),
      Text(currentValue.name)
          .fontFamily(AppStyles.fontFamilyBody)
          .fontSize(30.sp),
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center);
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: customInputDecoration(
        labelText: 'Category',
        enabled: true,
        errorText: errorText,
      ),
      child: child,
    ).gestures(onTap: () => showOptions(context)).padding(vertical: 10.h);
  }
}
