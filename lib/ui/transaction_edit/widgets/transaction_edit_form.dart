import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/dto/dto.dart';
import '../../../core/network/model/model.dart';
import '../../../shared/common/utils/utils.dart';
import '../../../shared/widget/widget.dart';

class TransactionEditForm extends StatefulWidget {
  const TransactionEditForm({
    Key key,
    @required this.data,
  }) : super(key: key);

  static const submitButtonTitle = 'Update';
  final Transaction data;

  @override
  _TransactionEditFormState createState() => _TransactionEditFormState();
}

class _TransactionEditFormState extends State<TransactionEditForm> {
  AmountFormatter amountFormatter;
  GlobalKey<FormState> form;
  TextEditingController amount;
  TextEditingController description;
  TransactionCategory category;
  String type;

  @override
  Widget build(BuildContext context) {
    final loading = context.select<TransactionEditCubit, bool>(
      (cubit) => cubit.state.maybeWhen(
        loading: () => true,
        orElse: () => false,
      ),
    );

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
          currentValue: type,
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
          loading: loading,
          title: TransactionEditForm.submitButtonTitle,
          onTap: onSubmit,
        ),
      ].toColumn(),
    );
  }

  @override
  void initState() {
    super.initState();
    final data = widget.data;
    form = GlobalKey<FormState>();
    amountFormatter = AmountFormatter();
    amount = TextEditingController(
        text: FormatCurrency.toIDR(data.amount).replaceAll('IDR', ''));
    description = TextEditingController(text: data.description);
    type = data.type;
    category = widget.data.category;
  }

  @override
  void dispose() {
    super.dispose();
    amount.dispose();
    description.dispose();
  }

  void onChangeType(String value) => setState(() => type = value);

  void onSubmit() {
    if (!form.currentState.validate()) return;

    final dto = TransactionEditDto(
      id: widget.data.id,
      amount: int.parse(amount.text.replaceAll('.', '')),
      categoryId: category.id,
      type: type,
      description: description.text,
    );
    context.read<TransactionEditCubit>().submit(dto);
  }
}
