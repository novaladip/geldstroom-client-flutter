import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/model/model.dart';
import '../../../shared/widget/widget.dart';

class CreditItem extends StatelessWidget {
  const CreditItem({
    Key key,
    @required this.data,
  }) : super(key: key);

  final TransactionCategory data;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      CachedNetworkImage(
        imageUrl: data.iconUrl,
        width: 66.w,
      ),
      SizedBox(width: 13.w),
      LinkText(
        text: data.credit,
        onOpen: onOpen,
        textStyle: TextStyle(
          fontSize: 28.sp,
        ),
      ).flexible(),
    ].toRow().padding(bottom: 25.h);
  }

  Future<void> onOpen(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    }
  }
}
