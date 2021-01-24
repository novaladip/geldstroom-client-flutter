import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/bloc.dart';
import '../../core/network/network.dart';
import 'widget/reset_password_form.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({
    Key key,
  }) : super(key: key);

  static const routeName = '/reset/password';
  static const appBarTitle = 'Reset Password';

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ResetPasswordPage.appBarTitle),
      ),
      body: SingleChildScrollView(
        child: ResetPasswordForm(),
      ),
    );
  }

  @override
  void initState() {
    if (context.read<RequestOtpCubit>().state.status != FormStatusIdle()) {
      context.read<RequestOtpCubit>().clear();
    }
    if (context.read<PasswordResetCubit>().state.status != FormStatusIdle()) {
      context.read<PasswordResetCubit>().clear();
    }

    super.initState();
  }
}
