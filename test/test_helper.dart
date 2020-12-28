import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetWrapper extends StatelessWidget {
  const WidgetWrapper(this.child);

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
          home: Scaffold(body: child),
        );
      },
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    @required this.routes,
    @required this.initialRoute,
  });

  final Map<String, Widget Function(BuildContext)> routes;
  final String initialRoute;

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
          initialRoute: initialRoute,
        );
      },
    );
  }
}

Widget buildTestableWidget(Widget child) {
  return Material(
    child: WidgetWrapper(child),
  );
}

Widget buildTestableBlocWidget({
  @required Map<String, Widget Function(BuildContext)> routes,
  String initialRoutes = '/',
}) {
  return Material(
    child: AppWrapper(
      initialRoute: initialRoutes,
      routes: routes,
    ),
  );
}

ResponseBody buildResponseBody({
  @required Map<String, dynamic> payload,
  int statusCode = 200,
  Map<String, List<String>> headers = const {
    Headers.contentTypeHeader: [Headers.jsonContentType]
  },
}) {
  return ResponseBody.fromString(
    json.encode(payload),
    statusCode,
    headers: headers,
  );
}
