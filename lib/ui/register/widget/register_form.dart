import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/register/register_cubit.dart';
import '../../../core/network/network.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/common/utils/input_validator/input_validator.dart';
import '../../../shared/widget/main_button/main_button.dart';
import '../../../shared/widget/widget.dart';
import '../../register_success/register_success_page.dart';

class RegisterForm extends StatefulWidget {
  static const submitButtonText = 'Sign up';
  static final emailInputKey = UniqueKey();
  static final firstNameInputKey = UniqueKey();
  static final lastNameInputKey = UniqueKey();
  static final passwordInputKey = UniqueKey();

  RegisterForm({
    Key key,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) => stateListener(state),
      child: Builder(
        builder: (context) {
          final state = context.watch<RegisterCubit>().state;
          final loading = state.status.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          final emailError = state.status.maybeWhen(
            error: (e) =>
                e.errorCode == UserErrorCode.duplicateEmail ? e.message : null,
            orElse: () => null,
          );

          return Form(
            key: form,
            child: SingleChildScrollView(
              child: <Widget>[
                CustomTextFormField(
                  key: RegisterForm.emailInputKey,
                  labelText: 'Email',
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) => InputValidator.email(value, 'Email'),
                  errorText: emailError,
                ),
                CustomTextFormField(
                  key: RegisterForm.firstNameInputKey,
                  labelText: 'First Name',
                  controller: firstName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      InputValidator.required(value, 'First name'),
                ),
                CustomTextFormField(
                  key: RegisterForm.lastNameInputKey,
                  labelText: 'Last Name',
                  controller: lastName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      InputValidator.required(value, 'Last name'),
                ),
                CustomTextFormField(
                  key: RegisterForm.passwordInputKey,
                  labelText: 'Password',
                  controller: password,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      InputValidator.required(value, 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20.h),
                MainButton(
                  loading: loading,
                  title: RegisterForm.submitButtonText,
                  onTap: onSubmit,
                ),
              ]
                  .toColumn()
                  .padding(horizontal: AppStyles.defaultPaddingHorizontal),
            ),
          );
        },
      ),
    );
  }

  void stateListener(RegisterState state) {
    state.status.maybeWhen(
      error: (e) => Flushbar(
        title: 'Register failed',
        message: e.message,
        backgroundColor: Colors.red,
        icon: Icon(Icons.warning).iconColor(Colors.white),
        duration: Duration(seconds: 2),
        flushbarStyle: FlushbarStyle.GROUNDED,
      )..show(context),
      success: () => Navigator.of(context)
          .pushNamedAndRemoveUntil(RegisterSuccessPage.routeName, (_) => false),
      orElse: () {},
    );
  }

  void onSubmit() {
    if (!form.currentState.validate()) return;

    final dto = RegisterDto(
      email: email.text,
      firstName: firstName.text,
      lastName: lastName.text,
      password: password.text,
    );
    context.read<RegisterCubit>().submit(dto);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
