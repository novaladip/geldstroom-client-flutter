import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jiffy/jiffy.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/network/model/model.dart';
import '../../../shared/common/config/config.dart';

class RequestCategoryItem extends StatelessWidget {
  const RequestCategoryItem({
    Key key,
    @required this.data,
    this.isDeleting = false,
    this.isLast = false,
    @required this.onDelete,
  }) : super(key: key);

  final RequestCategory data;
  final bool isDeleting;
  final bool isLast;
  final VoidCallback onDelete;

  BorderStyle get borderStyle => isLast ? BorderStyle.none : BorderStyle.solid;

  bool get showSlideActions => isDeleting || data.status == 'ON_REVIEW';

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: [
        if (showSlideActions)
          ...<Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: onDelete,
            ),
          ].toList(),
      ],
      child: <Widget>[
        RequestCategoryItemLeft(
          categoryName: data.categoryName,
          updatedAt: data.updatedAt,
        ).expanded(flex: 2),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: RequestCategoryItemRight(
            status: data.status,
            isDeleting: isDeleting,
          ),
        ),
      ]
          .toRow()
          .padding(
            horizontal: AppStyles.defaultPaddingHorizontal,
            vertical: 15.h,
          )
          .border(bottom: 1, color: AppStyles.primaryColor, style: borderStyle)
          .backgroundColor(AppStyles.darkBackground),
    ).backgroundColor(AppStyles.darkBackground);
  }
}

class RequestCategoryItemLeft extends StatelessWidget {
  const RequestCategoryItemLeft({
    Key key,
    @required this.categoryName,
    @required this.updatedAt,
  }) : super(key: key);

  final String categoryName;
  final DateTime updatedAt;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Text(categoryName).fontSize(32.sp).fontWeight(FontWeight.bold),
      SizedBox(height: 5.h),
      buildDate(updatedAt, 'Updated at: '),
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  String _formatDate(DateTime date) => Jiffy(date).format('mm/dd/yyyy hh:mm a');

  Widget buildDate(DateTime date, String title) {
    return <Widget>[
      Text(title),
      Text(_formatDate(date)),
    ].toRow();
  }
}

class RequestCategoryItemRight extends StatelessWidget {
  const RequestCategoryItemRight({
    Key key,
    @required this.status,
    @required this.isDeleting,
  }) : super(key: key);

  final String status;
  final bool isDeleting;

  Color get color {
    switch (status) {
      case 'APPROVED':
        return Colors.green;

      case 'ON_REVIEW':
        return Colors.blue;

      default:
        return Colors.red;
    }
  }

  String get formattedStatus => status.replaceAll('_', ' ');

  @override
  Widget build(BuildContext context) {
    if (isDeleting) {
      return SpinKitChasingDots(color: Colors.white, size: 50.sp);
    }

    return Text(formattedStatus)
        .fontWeight(FontWeight.bold)
        .textAlignment(TextAlign.end)
        .padding(all: 13.sp)
        .decorated(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
        );
  }
}
