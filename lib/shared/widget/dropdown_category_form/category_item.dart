import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/network/model/model.dart';
import '../../common/config/config.dart';

class CategoryItem extends StatelessWidget {
  final VoidCallback onTap;
  final TransactionCategory data;
  final bool isSelected;

  const CategoryItem({
    Key key,
    this.onTap,
    this.data,
    this.isSelected,
  }) : super(key: key);

  Color get textColor => isSelected ? AppStyles.primaryColor : Colors.white;
  FontWeight get textFontWeight =>
      isSelected ? FontWeight.bold : FontWeight.normal;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      CachedNetworkImage(imageUrl: data.iconUrl, height: 40.h),
      SizedBox(width: 13.w),
      Text(data.name)
          .fontSize(32.sp)
          .textColor(textColor)
          .fontWeight(textFontWeight)
          .fontFamily(AppStyles.fontFamilyBody)
          .gestures(onTap: onTap)
    ].toRow().padding(vertical: 13.h);
  }
}
