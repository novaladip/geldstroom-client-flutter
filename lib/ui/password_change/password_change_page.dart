import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/bloc/bloc.dart';
import '../../shared/common/utils/utils.dart';
import 'widgets/password_change_form.dart';
import 'widgets/password_change_header.dart';

class PasswordChangePage extends StatelessWidget {
  static const routeName = '/change/password';

  const PasswordChangePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<PasswordChangeCubit, PasswordChangeState>(
          listener: passwordChangeStateListener,
          child: SingleChildScrollView(
            child: <Widget>[
              PasswordChangeHeader(),
              PasswordChangeForm(),
            ].toColumn(),
          ),
        ),
      ),
    );
  }

  void passwordChangeStateListener(
    BuildContext context,
    PasswordChangeState state,
  ) {
    state.status.maybeWhen(
      error: (e) => CustomSnackbar.createError(
        message: e.message,
      )..show(context),
      success: () => Navigator.of(context).pop(),
      orElse: () {},
    );
  }
}
