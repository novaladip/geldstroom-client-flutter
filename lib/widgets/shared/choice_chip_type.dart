import 'package:flutter/material.dart';

class ChoiceChipType extends StatelessWidget {
  final selectedType;
  final Function(String) onSelected;
  final _typeList = [
    'INCOME',
    'EXPENSE',
  ];

  ChoiceChipType({
    Key key,
    @required this.selectedType,
    @required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Type'),
          Wrap(
            children: List<Widget>.generate(
              _typeList.length,
              (int index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: ChoiceChip(
                  selectedColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  labelStyle: TextStyle(color: Colors.white),
                  label: Text(_typeList[index]),
                  selected: selectedType == _typeList[index],
                  onSelected: (bool selected) => onSelected(_typeList[index]),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
