// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';

/// find given to from RichText
/// ```
/// final textFinder = find.
/// byWidgetPredicate((widget) => fromRichTextToPlainText(widget, 'Hello World!'));
/// expect(textFinder, findsOneWidget)
/// ```
bool fromRichTextToPlainText(Widget widget, String text) {
  if (widget is RichText) {
    if (widget.text is TextSpan) {
      final buffer = StringBuffer();
      (widget.text as TextSpan).computeToPlainText(buffer);

      return buffer.toString() == text;
    }
  }
  return false;
}
