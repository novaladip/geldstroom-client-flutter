import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/bloc_base/bloc_base.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/common/utils/utils.dart';
import '../../../shared/widget/widget.dart';

class LoginVerifyEmail extends StatefulWidget {
  const LoginVerifyEmail({
    Key key,
    @required this.email,
  }) : super(key: key);

  final String email;

  @override
  _LoginVerifyEmailState createState() => _LoginVerifyEmailState();
}

class _LoginVerifyEmailState extends State<LoginVerifyEmail> {
  bool success = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ResendEmailVerificationCubit, FormNoneState>(
        listener: resendEmailVerificationCubitListener,
        child: Styled.widget(
          child: <Widget>[
            Assets.images.fetchError.svg(
              height: 0.25.sh,
            ),
            SizedBox(height: 25.h),
            Text('${widget.email} is not verified yet')
                .fontSize(30.sp)
                .fontWeight(FontWeight.bold),
            SizedBox(height: 25.h),
            Builder(
              builder: (context) {
                final loading =
                    context.select<ResendEmailVerificationCubit, bool>(
                  (cubit) => cubit.state.status.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ),
                );

                return MainButton(
                  loading: loading,
                  title: success ? 'Close' : 'Send Email Verification',
                  onTap: success ? pop : onSubmit,
                );
              },
            ),
          ].toColumn(),
        ),
      ),
    )
        .height(0.43.sh)
        .padding(
          vertical: 25.h,
          horizontal: AppStyles.defaultPaddingHorizontal,
        )
        .backgroundColor(AppStyles.darkBackground);
  }

  @override
  void initState() {
    super.initState();
    context.read<ResendEmailVerificationCubit>().clear();
  }

  void resendEmailVerificationCubitListener(
    BuildContext context,
    FormNoneState state,
  ) {
    state.status.maybeWhen(
      error: (e) {
        CustomSnackbar.createError(
          message: e.message,
        )..show(context);
      },
      success: () {
        setState(() {
          success = true;
        });
        CustomSnackbar.createSuccess(
          message: 'An verification link has been send to your email',
        )..show(context);
      },
      orElse: () {},
    );
  }

  void onSubmit() {
    context.read<ResendEmailVerificationCubit>().submit(widget.email);
  }

  void pop() {
    Navigator.of(context).pop();
  }
}
