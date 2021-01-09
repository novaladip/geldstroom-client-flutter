import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/config/config.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key key,
    this.validator,
    @required this.labelText,
    this.enabled = true,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.unspecified,
    this.onFieldSubmitted,
    this.controller,
    this.obscureText = false,
    this.onSaved,
    this.errorText,
    this.helperText,
    this.onTap,
    this.initialValue,
    this.onChanged,
    this.inputFormatters = const [],
  }) : super(key: key);

  final String Function(String) validator;
  final void Function() onFieldSubmitted;
  final String labelText;
  final bool enabled;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final bool obscureText;
  final String errorText;
  final Function(String) onSaved;
  final String helperText;
  final void Function() onTap;
  final String initialValue;
  final Function(String) onChanged;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    final inputDecoration = InputDecoration(
      focusColor: color,
      contentPadding: EdgeInsets.symmetric(horizontal: 13.w),
      labelStyle: TextStyle(
        fontFamily: AppStyles.fontFamilyTitle,
        color: AppStyles.textGray,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.8,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      filled: true,
      labelText: labelText,
      enabled: enabled,
      errorText: errorText,
      helperText: helperText,
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: TextFormField(
        autocorrect: false,
        initialValue: initialValue,
        style: TextStyle(
          fontFamily: AppStyles.fontFamilyTitle,
          color: AppStyles.textWhite,
        ),
        enabled: enabled,
        onTap: onTap,
        controller: controller,
        obscureText: obscureText,
        onSaved: onSaved,
        focusNode: focusNode,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: (_) => onFieldSubmitted(),
        inputFormatters: inputFormatters,
        decoration: inputDecoration,
        cursorColor: AppStyles.primaryColor,
        keyboardAppearance: Brightness.dark,
      ),
    );
  }
}
