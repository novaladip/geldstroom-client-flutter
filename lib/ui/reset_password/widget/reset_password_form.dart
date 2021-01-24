import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/dto/dto.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/common/utils/utils.dart';
import '../../../shared/widget/widget.dart';
import 'reset_password_email_form.dart';
import 'reset_password_success.dart';

class ResetPasswordForm extends StatefulWidget {
  ResetPasswordForm({Key key}) : super(key: key);

  static const submitButtonText = 'Submit';
  static const otpInputKey = Key('reset_password_form_otp_input');
  static const passwordInputKey = Key('reset_password_form_password_input');
  static const password2InputKey = Key('reset_password_form_password2_input');

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final password2 = TextEditingController();
  final otp = TextEditingController();
  bool showOtherForm = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ResetPasswordCubit>().state;
    final isLoading = state.status.maybeWhen<bool>(
      loading: () => true,
      orElse: () => false,
    );

    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) => resetPasswordListener(state),
      child: Form(
        key: form,
        child: <Widget>[
          ResetPasswordEmailForm(controller: email),
          if (state.showAllForm)
            ...<Widget>[
              CustomTextFormField(
                key: ResetPasswordForm.otpInputKey,
                labelText: 'OTP',
                controller: otp,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (v) => InputValidator.required(v, 'OTP'),
                errorText: state.status.maybeWhen(
                    orElse: () => null,
                    error: (e) => e.error['otp'] ?? e.error['OTP']),
              ),
              CustomTextFormField(
                key: ResetPasswordForm.passwordInputKey,
                labelText: 'Password',
                obscureText: true,
                errorText: state.status.maybeWhen(
                  orElse: () => null,
                  error: (e) => e.error['password'],
                ),
                controller: password,
                textInputAction: TextInputAction.next,
                validator: (v) => InputValidator.required(v, 'Password'),
              ),
              CustomTextFormField(
                key: ResetPasswordForm.password2InputKey,
                labelText: 'Password Confirmation',
                controller: password2,
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (v) =>
                    InputValidator.required(v, 'Password confirmation') ??
                    InputValidator.isEqual(
                      v,
                      password.text,
                      'Password confirmation',
                    ),
              ),
              SizedBox(height: 13.h),
              MainButton(
                loading: isLoading,
                title: ResetPasswordForm.submitButtonText,
                onTap: onSubmit,
              ),
            ].toList()
        ].toColumn().padding(horizontal: AppStyles.defaultPaddingHorizontal),
      ),
    );
  }

  void resetPasswordListener(ResetPasswordState state) {
    state.status.maybeWhen(
      success: () => showMaterialModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (context) => ResetPasswordSuccess(),
      ),
      error: (e) => CustomSnackbar.createError(
        title: 'Reset password failed',
        message: e.message,
      )..show(context),
      orElse: () {},
    );
  }

  void onSubmit() {
    if (!form.currentState.validate()) return;
    final dto = PasswordResetDto(
      email: email.text,
      otp: otp.text,
      password: password.text,
    );
    context.read<ResetPasswordCubit>().submit(dto);
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    password2.dispose();
    otp.dispose();
    super.dispose();
  }
}
