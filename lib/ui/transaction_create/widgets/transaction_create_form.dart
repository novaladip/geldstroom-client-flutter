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

class TransactionCreateForm extends StatefulWidget {
  const TransactionCreateForm({
    Key key,
  }) : super(key: key);

  static const submitButtonTitle = 'Submit';
  static const descriptionFormKey = Key('transaction_create_form_description');
  static const amountFormKey = Key('transaction_create_form_amount');
  static const typeFormKey = Key('transaction_create_form_type');
  static const categoryFormKey = Key('transaction_create_form_category');

  @override
  _TransactionCreateFormState createState() => _TransactionCreateFormState();
}

class _TransactionCreateFormState extends State<TransactionCreateForm> {
  AmountFormatter amountFormatter;
  GlobalKey<FormState> form;
  TextEditingController amount;
  TextEditingController description;
  TransactionCategory category;
  String type;

  String categoryError;

  @override
  Widget build(BuildContext context) {
    final loading = context.select<TransactionCreateCubit, bool>(
      (cubit) => cubit.state.maybeWhen(
        orElse: () => false,
        loading: () => true,
      ),
    );

    return Form(
      key: form,
      child: <Widget>[
        CustomTextFormField(
          key: TransactionCreateForm.descriptionFormKey,
          labelText: 'Description',
          controller: description,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        CustomTextFormField(
          key: TransactionCreateForm.amountFormKey,
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
          key: TransactionCreateForm.typeFormKey,
          labelText: 'Type',
          currentValue: type,
          onChanged: onChangeType,
          options: ['EXPENSE', 'INCOME'],
          renderItem: (value) =>
              Text(value[0] + value.substring(1).toLowerCase()),
        ),
        DropdownCategoryForm(
          key: TransactionCreateForm.categoryFormKey,
          errorText: categoryError,
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
          title: TransactionCreateForm.submitButtonTitle,
          onTap: onSubmit,
        ),
      ].toColumn(),
    );
  }

  @override
  void initState() {
    super.initState();
    amountFormatter = AmountFormatter();
    form = GlobalKey();
    amount = TextEditingController();
    description = TextEditingController();
    category = context.read<CategoryCubit>().state.data.isEmpty
        ? null
        : context.read<CategoryCubit>().state.data[0];
    type = 'EXPENSE';
  }

  @override
  void dispose() {
    amount.dispose();
    description.dispose();
    super.dispose();
  }

  void onChangeType(String value) => setState(() => type = value);

  void changeCategoryError(String value) =>
      setState(() => categoryError = value);

  void onSubmit() {
    changeCategoryError(
      category == null ? 'Category is cannot be empty' : null,
    );
    if (!form.currentState.validate() || categoryError != null) return;
    final dto = TransactionCreateDto(
      amount: int.parse(amount.text.replaceAll('.', '')),
      description: description.text,
      categoryId: category.id,
      type: type,
    );
    context.read<TransactionCreateCubit>().submit(dto);
  }
}
