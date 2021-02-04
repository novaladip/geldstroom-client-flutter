import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/styles/styles.dart';

class DateFormField extends StatelessWidget {
  const DateFormField({
    Key key,
    @required this.currentValue,
    @required this.labelText,
    @required this.onChange,
    this.errorText,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  final String labelText;
  final String errorText;
  final DateTime currentValue;
  final Function(DateTime value) onChange;
  final DateTime firstDate;
  final DateTime lastDate;

  String get formattedCurrentValue => Jiffy(currentValue).format('MM-dd-yyyy');

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: customInputDecoration(
        labelText: labelText,
        enabled: true,
        errorText: errorText,
      ),
      child: Text(formattedCurrentValue),
    ).gestures(onTap: () => openDatePicker(context)).padding(vertical: 10.h);
  }

  Future<void> openDatePicker(BuildContext context) async {
    final result = await showDatePicker(
      context: context,
      firstDate: firstDate ?? Jiffy(currentValue).startOf(Units.MONTH),
      lastDate: lastDate ?? Jiffy(currentValue).endOf(Units.MONTH),
      initialDate: currentValue,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    if (result == null) return;
    onChange(result);
  }
}
