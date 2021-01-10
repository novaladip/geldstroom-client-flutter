import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../common/config/config.dart';
import '../../common/styles/styles.dart';

class DropdownForm<Option> extends StatelessWidget {
  final List<Option> options;
  final Option currentValue;
  final String labelText;
  final String errorText;
  final String helperText;
  final bool enabled;
  final Function(Option) onChanged;
  final Widget Function(Option) renderItem;

  const DropdownForm({
    Key key,
    @required this.currentValue,
    @required this.options,
    @required this.labelText,
    @required this.onChanged,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.renderItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputDecoration = customInputDecoration(
      labelText: labelText,
      errorText: errorText,
      helperText: helperText,
      enabled: enabled,
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: InputDecorator(
        decoration: inputDecoration,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Option>(
            dropdownColor: AppStyles.darkBackground,
            onChanged: onChanged,
            isDense: true,
            icon: Icon(Icons.arrow_drop_down_circle).iconColor(Colors.white),
            value: currentValue,
            items: options
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: renderItem(value),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
