import 'package:flutter/material.dart';

class ChoiceChipCategory extends StatelessWidget {
  final selectedCategory;
  final Function(String) onSelected;
  final _categoryList = ['FOOD', 'HOBBY', 'EDUCATION'];

  ChoiceChipCategory({
    Key key,
    @required this.selectedCategory,
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
          Text(' Category'),
          Wrap(
            children: List<Widget>.generate(
              _categoryList.length,
              (int index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: ChoiceChip(
                  selectedColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey,
                  labelStyle: TextStyle(color: Colors.white),
                  label: Text(_categoryList[index]),
                  selected: selectedCategory == _categoryList[index],
                  onSelected: (bool selected) =>
                      onSelected(_categoryList[index]),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }
}
