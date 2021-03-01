import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/config/config.dart';

/// LinkText will split the given text by whitespace
/// if the element is an URL string, it will overriding
/// the text style color to [linkColor]
/// otherwise it will render with given textStyle
/// ```
/// LinkText(
///   text: 'Breaking news! https://url.com',
///   textStyle: TextStlye(),
///   linkColor: Colors.blue, // Optional default value is AppStyles.primaryColor
///   onOpen: (String value) {}
/// )
/// ```
class LinkText extends StatelessWidget {
  const LinkText({
    Key key,
    @required this.text,
    @required this.onOpen,
    @required this.textStyle,
    this.linkColor = AppStyles.primaryColor,
  }) : super(key: key);

  final String text;
  final Function(String value) onOpen;
  final TextStyle textStyle;
  final Color linkColor;

  TextStyle get linkStyle => textStyle.copyWith(color: linkColor);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: buildTextSpan(),
      ),
    );
  }

  List<TextSpan> buildTextSpan() {
    final textSpan = <TextSpan>[];
    final listText = text.split(' ');

    listText.asMap().forEach((index, value) {
      final isLast = listText.length - 1 == index;
      // add a space to value if it is the last element
      final formattedText = isLast ? value : '$value ';
      // check if value is an URL
      final isUrl = urlRegExp.hasMatch(value);
      final tapGesture = TapGestureRecognizer()..onTap = () => onOpen(value);

      textSpan.add(
        TextSpan(
          text: formattedText,
          style: isUrl ? linkStyle : textStyle,
          recognizer: isUrl ? tapGesture : null,
        ),
      );
    });

    return textSpan;
  }
}

final urlRegExp = RegExp(
  r'[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
  caseSensitive: false,
  multiLine: false,
);
