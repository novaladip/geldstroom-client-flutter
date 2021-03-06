import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jiffy/jiffy.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/network/model/model.dart';
import '../../common/config/config.dart';
import '../../common/utils/utils.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    Key key,
    @required this.data,
    this.isDeleting = false,
    @required this.onDelete,
    @required this.onEdit,
  }) : super(key: key);

  final Transaction data;
  final bool isDeleting;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  Color get borderColor =>
      data.type.toLowerCase() == 'income' ? Colors.green : Colors.red;
  String get formattedAmount => FormatCurrency.toIDR(data.amount);

  String get formattedCreatedAt {
    final aWeekAgo = DateTime.now().subtract(Duration(days: 7));

    if (data.createdAt.isBefore(aWeekAgo)) {
      return FormatDate.normal(data.createdAt);
    }

    return Jiffy(data.createdAt).fromNow();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      closeOnScroll: true,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: [
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: onEdit,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: onDelete,
        ),
      ],
      child: <Widget>[
        <Widget>[
          if (isDeleting)
            SpinKitChasingDots(
              color: Colors.white,
              size: 35.sp,
            ),
          if (!isDeleting)
            CachedNetworkImage(
              imageUrl: data.category.iconUrl,
              width: 50.w,
              fit: BoxFit.fitHeight,
            ),
          SizedBox(width: 13.w),
          Text(data.category.name)
              .fontSize(29.sp)
              .fontFamily(AppStyles.fontFamilyBody)
              .fontWeight(FontWeight.w500),
        ].toRow(),
        <Widget>[
          Text(formattedAmount)
              .fontSize(29.sp)
              .fontFamily(AppStyles.fontFamilyBody),
          SizedBox(height: 3.h),
          Text(formattedCreatedAt)
              .fontSize(23.sp)
              .fontFamily(AppStyles.fontFamilyBody)
              .textColor(Colors.grey),
        ].toColumn(
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
      ]
          .toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
          .padding(
            horizontal: AppStyles.defaultPaddingHorizontal / 2,
            vertical: 8.h,
          )
          .border(
            right: 4.w,
            color: borderColor,
          )
          .backgroundColor(AppStyles.darkBackground),
    ).backgroundColor(AppStyles.darkBackground);
  }
}
