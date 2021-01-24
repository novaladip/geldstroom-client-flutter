import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/dto/dto.dart';
import '../../../core/network/model/model.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/common/utils/utils.dart';
import '../../../shared/widget/widget.dart';
import '../../ui.dart';

class LoginForm extends StatefulWidget {
  static const submitButtonText = 'Sign in';
  static const forgotPasswordText = 'Forgot Password';
  static const emailInputKey = Key('login_form_email_input');
  static const passwordInputKey = Key('login_form_password_input');
  static const submitButtonKey = Key('login_form_submit_button');

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
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            state.status.maybeWhen(
              error: (e) {
                Flushbar(
                  key: Key('login_form_flushbar_failed'),
                  title: 'Login failed',
                  icon:
                      Icon(Icons.error_outline_rounded).iconColor(Colors.white),
                  message: e.message,
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  flushbarStyle: FlushbarStyle.FLOATING,
                )..show(context);
              },
              success: () {
                Flushbar(
                  title: 'Login success',
                  message:
                      'You will be redirected to home page in a few moment',
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                  flushbarStyle: FlushbarStyle.FLOATING,
                )..show(context);
              },
              orElse: () {},
            );
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            state.maybeWhen(
              authenticated: () => Navigator.of(context)
                  .pushReplacementNamed(HomePage.routeName),
              orElse: () {},
            );
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final state = context.watch<LoginCubit>().state;
          return Form(
            key: form,
            child: <Widget>[
              CustomTextFormField(
                key: LoginForm.emailInputKey,
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
                key: LoginForm.passwordInputKey,
                labelText: 'Password',
                controller: password,
                focusNode: passwordFocusNode,
                obscureText: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) =>
                    InputValidator.required(value, 'Password'),
                errorText: state.status.maybeWhen(
                  error: (e) => e.errorCode == UserErrorCode.invalidCredentials
                      ? e.message
                      : null,
                  orElse: () => null,
                ),
              ),
              SizedBox(height: 4.h),
              Text(LoginForm.forgotPasswordText)
                  .textColor(AppStyles.textGray)
                  .alignment(Alignment.centerRight)
                  .gestures(
                      onTap: () => Navigator.of(context)
                          .pushNamed(PasswordResetPage.routeName)),
              SizedBox(height: 20.h),
              MainButton(
                key: LoginForm.submitButtonKey,
                title: LoginForm.submitButtonText,
                onTap: onSubmit,
                loading: state.status.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                ),
              ),
            ].toColumn().padding(horizontal: 30.w, top: 50.h),
          );
        },
      ),
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
