import 'package:flutter/material.dart';
import 'package:geldstroom/models/transaction.dart';
import 'package:geldstroom/utils/format_currency.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  TransactionItem({this.transaction});

  String get _date {
    final parsedDate = DateTime.parse(transaction.createdAt);
    return DateFormat.yMd().format(parsedDate);
  }

  String get _amount {
    final prefix = transaction.type == 'INCOME' ? '+ ' : '- ';
    return prefix + formatCurrency(transaction.amount);
  }

  String get _imageCategory {
    return 'assets/images/category/${transaction.category}.png';
  }

  Widget _buildLeftItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Image.asset(
            _imageCategory,
            width: 18,
          ),
        ),
        VerticalDivider(),
        Text(transaction.category)
      ],
    );
  }

  Widget _buildRightItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          _amount,
          style: TextStyle(
            color: transaction.type == 'INCOME' ? Colors.green : Colors.red,
          ),
        ),
        Text(
          _date,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildLeftItem(),
            _buildRightItem(),
          ],
        ),
      ),
    );
  }
}
