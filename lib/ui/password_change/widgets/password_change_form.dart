import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/dto/dto.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/common/utils/utils.dart';
import '../../../shared/widget/widget.dart';

class PasswordChangeForm extends StatefulWidget {
  const PasswordChangeForm({
    Key key,
  }) : super(key: key);

  static const oldPasswordKey = Key('password_change_form_old_password');
  static const passwordKey = Key('password_change_form_password');
  static const password2Key = Key('password_change_form_password2');

  @override
  _PasswordChangeFormState createState() => _PasswordChangeFormState();
}

class _PasswordChangeFormState extends State<PasswordChangeForm> {
  GlobalKey<FormState> form;
  TextEditingController oldPassword;
  TextEditingController password;
  TextEditingController password2;

  @override
  void initState() {
    super.initState();
    form = GlobalKey<FormState>();
    oldPassword = TextEditingController();
    password = TextEditingController();
    password2 = TextEditingController();
    context.read<PasswordChangeCubit>().clear();
  }

  @override
  void dispose() {
    oldPassword.dispose();
    password.dispose();
    password2.dispose();
    super.dispose();
  }

  void onSubmit() {
    if (!form.currentState.validate()) return;

    final dto = ChangePasswordDto(
      oldPassword: oldPassword.text,
      password: password.text,
      passwordConfirmation: password2.text,
    );
    context.read<PasswordChangeCubit>().submit(dto);
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.select<PasswordChangeCubit, bool>(
      (cubit) => cubit.state.status.maybeWhen(
        orElse: () => false,
        loading: () => true,
      ),
    );
    final error = context.select<PasswordChangeCubit, Map<String, dynamic>>(
      (cubit) => cubit.state.status.maybeWhen(
        orElse: () => {},
        error: (e) => e.error,
      ),
    );

    return Form(
      key: form,
      child: <Widget>[
        CustomTextFormField(
          key: PasswordChangeForm.oldPasswordKey,
          labelText: 'Old Password',
          controller: oldPassword,
          textInputAction: TextInputAction.next,
          obscureText: true,
          errorText: error['oldPassword'],
          validator: (v) => InputValidator.required(v, 'Old password'),
        ),
        CustomTextFormField(
          key: PasswordChangeForm.passwordKey,
          labelText: 'New Password',
          controller: password,
          textInputAction: TextInputAction.next,
          obscureText: true,
          errorText: error['password'],
          validator: (v) => InputValidator.required(v, 'Password'),
        ),
        CustomTextFormField(
          key: PasswordChangeForm.password2Key,
          labelText: 'New Password Confirmation',
          controller: password2,
          textInputAction: TextInputAction.done,
          obscureText: true,
          errorText: error['passwordConfirmation'],
          validator: (v) => InputValidator.isEqual(
            v,
            password.text,
            'Password confirmation',
          ),
        ),
        SizedBox(height: 25.h),
        MainButton(
          title: 'Submit',
          loading: loading,
          onTap: onSubmit,
        ),
      ].toColumn().padding(horizontal: AppStyles.defaultPaddingHorizontal),
    );
  }
}
