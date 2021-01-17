import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/network/model/model.dart';
import '../../shared/common/config/config.dart';
import 'widgets/transaction_edit_form.dart';
import 'widgets/transaction_edit_header.dart';

class TransactionEditPage extends StatefulWidget {
  const TransactionEditPage({
    Key key,
    @required this.data,
  }) : super(key: key);

  static const routeName = '/transaction/edit';

  final Transaction data;

  @override
  _TransactionEditPageState createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        TransactionEditHeader(),
        TransactionEditForm(data: widget.data),
        SizedBox(height: 100.h),
      ]
          .toColumn()
          .padding(horizontal: AppStyles.defaultPaddingHorizontal)
          .scrollable(),
    ).height(0.88.sh);
  }
}
