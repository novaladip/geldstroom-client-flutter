import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/network/model/model.dart';

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
      Linkify(
        text: data.credit,
        onOpen: onOpen,
      ).flexible(),
    ].toRow().padding(bottom: 25.h);
  }

  Future<void> onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    }
  }
}
