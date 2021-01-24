import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc/bloc.dart';
import '../../core/network/network.dart';
import 'widget/password_reset_form.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({
    Key key,
  }) : super(key: key);

  static const routeName = '/reset/password';
  static const appBarTitle = 'Reset Password';

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PasswordResetPage.appBarTitle),
      ),
      body: SingleChildScrollView(
        child: PasswordResetForm(),
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
