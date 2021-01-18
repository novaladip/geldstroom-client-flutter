import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/bloc/bloc.dart';
import '../../core/network/model/model.dart';
import '../../shared/common/config/config.dart';
import '../../shared/common/utils/utils.dart';
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
      body: BlocListener<TransactionEditCubit, FormStatusData<Transaction>>(
        listener: transactionEditStateListener,
        child: <Widget>[
          TransactionEditHeader(),
          TransactionEditForm(data: widget.data),
          SizedBox(height: 100.h),
        ]
            .toColumn()
            .padding(horizontal: AppStyles.defaultPaddingHorizontal)
            .scrollable(),
      ),
    ).height(0.88.sh);
  }

  void transactionEditStateListener(
    BuildContext context,
    FormStatusData<Transaction> state,
  ) {
    state.maybeWhen(
      error: (e) => CustomSnackbar.createError(
        message: e.message,
        duration: Duration(seconds: 3),
      )..show(context),
      success: (_) => Navigator.of(context).pop(),
      orElse: () {},
    );
  }
}
