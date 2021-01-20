import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/widget/widget.dart';

class ProfileItem extends StatelessWidget {
  ProfileItem({
    Key key,
  }) : super(key: key);

  Widget get errorChild => Text('Failed to load profile data, pull to refresh.')
      .fontFamily(AppStyles.fontFamilyBody)
      .center();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    return SafeArea(
      child: state.when(
        loadFailure: (_) => errorChild,
        loadInProgress: () => LoadingIndicator(),
        loadSucess: (data) => <Widget>[
          CircleAvatar(
            maxRadius: 40.sp,
            backgroundImage: CachedNetworkImageProvider(data.avatar),
          ),
          SizedBox(width: 20.w),
          <Widget>[
            Text('${data.firstName} ${data.lastName}')
                .fontSize(30.sp)
                .fontFamily(AppStyles.fontFamilyBody)
                .fontWeight(FontWeight.w600),
            SizedBox(height: 3.h),
            Text(data.email)
                .fontSize(30.sp)
                .fontFamily(AppStyles.fontFamilyBody)
                .fontWeight(FontWeight.w400)
                .textColor(AppStyles.textGray),
          ].toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ].toRow().padding(
              horizontal: AppStyles.defaultPaddingHorizontal,
              top: 30.h,
            ),
      ),
    );
  }
}
