import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:geldstroom/config/routes.dart';

class AppWrapper extends StatelessWidget {
  AppWrapper(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        ScreenUtil.init(
          constraints,
          designSize: Size(750, 1334),
          allowFontScaling: true,
        );
        return MaterialApp(
          routes: routes,
          home: child,
        );
      },
    );
  }
}

Widget buildTestableWidget(Widget child) {
  return AppWrapper(child);
}
