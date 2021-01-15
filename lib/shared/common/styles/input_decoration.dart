import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/config.dart';

InputDecoration customInputDecoration({
  @required String labelText,
  String errorText,
  bool enabled = false,
  String helperText,
}) {
  return InputDecoration(
    focusColor: AppStyles.primaryColor,
    contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
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
        color: AppStyles.primaryColor,
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
}
