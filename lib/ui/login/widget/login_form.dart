import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/dto/dto.dart';
import '../../../core/network/model/model.dart';
import '../../../shared/common/utils/utils.dart';
import '../../../shared/widget/widget.dart';
import '../../ui.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        state.status.maybeWhen(
          success: () => Navigator.of(context)
              .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false),
          error: (e) => Flushbar(
            title: 'Login failed',
            icon: Icon(Icons.error_outline_rounded).iconColor(Colors.white),
            message: e.message,
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            flushbarStyle: FlushbarStyle.FLOATING,
          )..show(context),
          orElse: () {},
        );
      },
      builder: (context, state) {
        return Form(
          key: form,
          child: <Widget>[
            CustomTextFormField(
              labelText: 'Email',
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: passwordFocusNode.requestFocus,
              validator: (value) => InputValidator.email(value, 'Email'),
              errorText: state.status.maybeWhen(
                error: (e) => e.errorCode == UserErrorCode.userNotFound
                    ? e.message
                    : null,
                orElse: () => null,
              ),
            ),
            CustomTextFormField(
              labelText: 'Password',
              controller: password,
              focusNode: passwordFocusNode,
              obscureText: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              validator: (value) => InputValidator.required(value, 'Password'),
              errorText: state.status.maybeWhen(
                error: (e) => e.errorCode == UserErrorCode.invalidCredentials
                    ? e.message
                    : null,
                orElse: () => null,
              ),
            ),
            SizedBox(height: 13.h),
            MainButton(
              title: 'Sign in',
              onTap: onSubmit,
              loading: state.status.maybeWhen(
                loading: () => true,
                orElse: () => false,
              ),
            ),
          ].toColumn().padding(horizontal: 30.w, top: 50.h),
        );
      },
    );
  }

  void onSubmit() {
    final isValid = form.currentState.validate();
    if (!isValid) return;

    final dto = LoginDto(email: email.text, password: password.text);
    context.read<LoginCubit>().submit(dto);
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
