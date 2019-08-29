import 'package:flutter/material.dart';

class SettingItem extends StatefulWidget {
  final String imageAssets;
  final String title;
  final VoidCallback onTap;

  SettingItem({
    @required this.imageAssets,
    @required this.title,
    @required this.onTap,
  });

  @override
  _SettingItemState createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  var _isTappedDown = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isTappedDown
          ? Colors.deepOrangeAccent.withOpacity(0.1)
          : Colors.white,
      margin: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isTappedDown = true),
        onTapUp: (_) => setState(() => _isTappedDown = false),
        child: Row(
          children: <Widget>[
            Image.asset(
              widget.imageAssets,
              height: 40,
            ),
            VerticalDivider(),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
