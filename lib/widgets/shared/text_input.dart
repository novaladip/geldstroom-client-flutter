import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String Function(String) validator;
  final void Function() onFieldSubmitted;
  final String labelText;
  final bool enabled;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController textEditingController;
  final double marginVertical;
  final bool obscureText;
  final String errorText;
  final Function(String) onSaved;
  final String helperText;
  final Icon icon;

  const TextInput({
    Key key,
    this.validator,
    @required this.labelText,
    this.enabled = true,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.unspecified,
    this.onFieldSubmitted,
    @required this.textEditingController,
    this.marginVertical = 10,
    this.obscureText = false,
    this.onSaved,
    this.errorText,
    this.helperText,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.symmetric(vertical: marginVertical),
      child: TextFormField(
        controller: textEditingController,
        obscureText: obscureText,
        onSaved: onSaved,
        focusNode: focusNode,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: (_) => onFieldSubmitted(),
        decoration: InputDecoration(
          border: Theme.of(context).inputDecorationTheme.border,
          labelText: labelText,
          enabled: enabled,
          errorText: errorText,
          helperText: helperText,
          prefixIcon: this.icon,
        ),
      ),
    );
  }
}
