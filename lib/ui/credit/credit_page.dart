import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../core/bloc/bloc.dart';
import '../../shared/common/config/config.dart';
import '../../shared/widget/widget.dart';
import 'widgets/credit_item.dart';

class CreditPage extends StatefulWidget {
  static const routeName = '/credit';

  const CreditPage({Key key}) : super(key: key);

  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          final state = context.watch<CategoryCubit>().state;

          return state.status.maybeWhen(
            loadFailure: (e) => ErrorMessageRetry(
              onRetry: fetch,
              message: e.message,
            ),
            loadInProgress: () => LoadingIndicator(),
            orElse: () => ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, index) => CreditItem(
                data: state.data[index],
              ),
            ),
          );
        },
      ).padding(horizontal: AppStyles.defaultPaddingHorizontal, top: 20.h),
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() {
    final cubit = context.read<CategoryCubit>();
    cubit.state.status.maybeWhen(
      orElse: cubit.fetch,
      loadSuccess: () {},
    );
  }
}
