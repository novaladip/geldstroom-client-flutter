import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/network.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/common/utils/utils.dart';
import '../../../shared/widget/widget.dart';

class PasswordResetEmailForm extends StatefulWidget {
  PasswordResetEmailForm({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  static const emailInputKey = Key('reset_password_email_email_input');
  static const loadingKey = Key('reset_password_email_loading');

  @override
  _PasswordResetEmailFormState createState() => _PasswordResetEmailFormState();
}

class _PasswordResetEmailFormState extends State<PasswordResetEmailForm> {
  int countdown = 0;
  String emailError;
  Timer timer;

  Widget styledText(
    String data, {
    Key key,
  }) =>
      Text(data, key: key)
          .fontFamily(AppStyles.fontFamilyTitle)
          .fontSize(32.sp)
          .fontWeight(FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RequestOtpCubit>().state;
    final emailApiError = context.select<PasswordResetCubit, String>(
      (cubit) => cubit.state.status.maybeWhen(
        error: (e) => e.errorCode == UserErrorCode.userNotFound
            ? e.message
            : e.error['email'],
        orElse: () => null,
      ),
    );
    final emailApiError2 = state.status.maybeWhen<String>(
      error: (e) => e.error['email'] ?? e.message,
      orElse: () => null,
    );

    return BlocListener<RequestOtpCubit, RequestOtpState>(
      listener: (context, state) => listener(state),
      child: <Widget>[
        CustomTextFormField(
          key: PasswordResetEmailForm.emailInputKey,
          labelText: 'Email',
          errorText: emailError ?? emailApiError ?? emailApiError2,
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          validator: (v) => InputValidator.email(v, 'Email'),
        ).expanded(),
        SizedBox(width: 30.w),
        state.status
            .maybeWhen<Widget>(
              orElse: () => styledText(
                countdown == 0 ? 'Resend' : countdown.toString(),
              ),
              idle: () => styledText('Send'),
              loading: () => SpinKitThreeBounce(
                key: PasswordResetEmailForm.loadingKey,
                color: Colors.white,
                size: 32.sp,
              ),
            )
            .gestures(onTap: onRequestOtp),
      ].toRow(),
    );
  }

  void listener(RequestOtpState state) {
    state.status.maybeWhen(
      error: (e) {
        CustomSnackbar.createError(
          message: e.message,
        )..show(context);
        startTimer();
      },
      success: () {
        CustomSnackbar.createSuccess(
          message: 'Code OTP has been send to your email',
        )..show(context);
        context.read<PasswordResetCubit>().changeShowAllForm(true);
        startTimer();
      },
      orElse: () {},
    );
  }

  void onRequestOtp() {
    if (countdown > 0) return;
    if (context.read<RequestOtpCubit>().state.status == FormStatus.loading()) {
      return;
    }

    setState(() {
      emailError = InputValidator.email(widget.controller.text, 'Email');
    });
    if (emailError != null) return;
    context.read<RequestOtpCubit>().submit(widget.controller.text);
  }

  void startTimer() {
    setState(() {
      countdown = 30;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          countdown -= 1;
        });
        if (countdown < 1) {
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
