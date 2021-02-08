import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/bloc/bloc.dart';
import '../../core/network/model/model.dart';
import '../../shared/common/config/config.dart';
import '../../shared/common/utils/utils.dart';
import 'widgets/transaction_create_form.dart';
import 'widgets/transaction_create_header.dart';

class TransactionCreatePage extends StatelessWidget {
  const TransactionCreatePage({
    Key key,
  }) : super(key: key);

  static const appbarTitle = 'Create Transaction';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TransactionCreateCubit, FormStatusData<Transaction>>(
        listener: transactionCreateListener,
        child: <Widget>[
          TransactionCreateHeader(),
          TransactionCreateForm(),
        ]
            .toColumn()
            .padding(horizontal: AppStyles.defaultPaddingHorizontal)
            .scrollable(),
      ),
    ).height(0.88.sh);
  }

  void transactionCreateListener(
    BuildContext context,
    FormStatusData<Transaction> state,
  ) {
    state.maybeWhen(
      error: (e) => CustomSnackbar.createError(
        message: e.message,
      )..show(context),
      success: (e) => Navigator.of(context).pop(),
      orElse: () {},
    );
  }
}
