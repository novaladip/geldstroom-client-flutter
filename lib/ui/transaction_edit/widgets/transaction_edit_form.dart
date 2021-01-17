import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/network/model/model.dart';
import '../../../shared/common/utils/utils.dart';
import '../../../shared/widget/widget.dart';

class TransactionEditForm extends StatefulWidget {
  const TransactionEditForm({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Transaction data;

  @override
  _TransactionEditFormState createState() => _TransactionEditFormState();
}

class _TransactionEditFormState extends State<TransactionEditForm> {
  AmountFormatter amountFormatter;
  GlobalKey<FormState> form;
  TextEditingController amount;
  TextEditingController description;
  TextEditingController type;
  TransactionCategory category;

  void onSubmit() {
    if (!form.currentState.validate()) return;
  }

  void onChangeType(String value) => setState(() => type.text = value);

  @override
  void initState() {
    final data = widget.data;
    form = GlobalKey<FormState>();
    amountFormatter = AmountFormatter();
    amount = TextEditingController(
        text: FormatCurrency.toIDR(data.amount).replaceAll('IDR', ''));
    description = TextEditingController(text: data.description);
    type = TextEditingController(text: data.type);
    category = widget.data.category;
    super.initState();
  }

  @override
  void dispose() {
    amount.dispose();
    description.dispose();
    type.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: <Widget>[
        CustomTextFormField(
          labelText: 'Description',
          controller: description,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        CustomTextFormField(
          labelText: 'Amount',
          controller: amount,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            amountFormatter,
          ],
          validator: InputValidator.amount,
        ),
        DropdownForm<String>(
          labelText: 'Type',
          currentValue: type.text,
          onChanged: onChangeType,
          options: ['EXPENSE', 'INCOME'],
          renderItem: (value) =>
              Text(value[0] + value.substring(1).toLowerCase()),
        ),
        DropdownCategoryForm(
          currentValue: category,
          onChange: (c) {
            setState(() {
              category = c;
            });
          },
        ),
        SizedBox(height: 20.h),
        MainButton(
          title: 'Update',
          onTap: onSubmit,
        ),
      ].toColumn(),
    );
  }
}
