import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../shared/common/config/config.dart';

class OverviewTransactionLoadingFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fetchMoreInProgress = context.select<OverviewTransactionBloc, bool>(
      (bloc) => bloc.state.status.maybeWhen<bool>(
        fetchMoreInProgress: () => true,
        orElse: () => false,
      ),
    );

    return <Widget>[
      if (fetchMoreInProgress)
        SpinKitCircle(
          size: 80.sp,
          color: Colors.white,
        ).center(),
      SizedBox(height: 100.h),
    ].toColumn().backgroundColor(AppStyles.darkBackground);
  }
}
