import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/bloc_base/bloc_base.dart';
import '../../../core/network/model/model.dart';
import '../../../shared/common/utils/utils.dart';
import 'request_category_item.dart';

class RequestCategoryList extends StatelessWidget {
  static const emptyText = 'There is no requested category yet';

  const RequestCategoryList({
    Key key,
    @required this.items,
    @required this.isEmpty,
  }) : super(key: key);

  final List<RequestCategory> items;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return Text(RequestCategoryList.emptyText).fontSize(30.sp).center();
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<RequestCategoryDeleteCubit, DeleteState>(
          listener: (context, _) => onDeleteSuccessIdsChanges(context),
          listenWhen: (prevState, state) =>
              state.shouldListenDeleteSuccess(prevState),
        ),
        BlocListener<RequestCategoryDeleteCubit, DeleteState>(
          listener: (context, _) => onDeleteFailureIdsChanges(context),
          listenWhen: (prevState, state) =>
              state.shoudListenDeleteFailure(prevState),
        ),
      ],
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => Builder(
          builder: (context) {
            final onDeleteProgressIds =
                context.select<RequestCategoryDeleteCubit, List<String>>(
              (cubit) => cubit.state.onDeleteProgressIds,
            );
            final data = items[index];
            final isDeleting = onDeleteProgressIds.contains(data.id);
            final isLast = index == items.length - 1;

            return RequestCategoryItem(
              data: data,
              isLast: isLast,
              isDeleting: isDeleting,
              onDelete: () =>
                  context.read<RequestCategoryDeleteCubit>().delete(data.id),
            );
          },
        ),
      ),
    );
  }

  void onDeleteSuccessIdsChanges(BuildContext context) {
    CustomSnackbar.createSuccess(
      message: 'Request category has been deleted',
    )..show(context);
  }

  void onDeleteFailureIdsChanges(BuildContext context) {
    CustomSnackbar.createError(
      message: 'Failed to delete request category',
    )..show(context);
  }
}
