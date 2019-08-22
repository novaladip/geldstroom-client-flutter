import 'package:flutter/material.dart';

class Quotes extends StatelessWidget {
  final String quote;
  const Quotes({
    Key key,
    @required this.quote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(40),
            bottomLeft: Radius.circular(20),
          ),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 2)
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        width: double.infinity,
        child: Center(
          child: Text(
            quote,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
