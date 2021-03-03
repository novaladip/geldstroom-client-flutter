import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc_ui/ui_bloc.dart';
import '../../../shared/common/config/config.dart';

class OverviewTitle extends StatelessWidget {
  static const title = 'Your transaction overview\nthis';

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Builder(builder: (context) {
        final overviewRange = context.select<OverviewRangeCubit, String>(
          (cubit) => cubit.state.when(
            monthly: () => 'month',
            weekly: () => 'week',
          ),
        );
        return Text('${OverviewTitle.title} $overviewRange')
            .fontSize(40.sp)
            .fontFamily(AppStyles.fontFamilyBody)
            .fontWeight(FontWeight.bold)
            .padding(right: 200.w)
            .padding(
              horizontal: AppStyles.defaultPaddingHorizontal,
            );
      }),
    );
  }
}
