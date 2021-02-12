import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../core/bloc/bloc.dart';
import '../../../core/network/dto/dto.dart';
import '../../../core/network/model/model.dart';
import '../../../shared/common/config/config.dart';
import '../../../shared/common/utils/utils.dart';
import '../../../shared/widget/widget.dart';
import 'confirmation_dialog.dart';

class RequestCategoryCreateForm extends StatefulWidget {
  static const nameInputKey = Key('request_category_create_form_name_input');
  static const descriptionInputKey =
      Key('request_category_create_form_description_input');

  @override
  _RequestCategoryCreateFormState createState() =>
      _RequestCategoryCreateFormState();
}

class _RequestCategoryCreateFormState extends State<RequestCategoryCreateForm> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final description = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<RequestCategoryCreateCubit>().clear();
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestCategoryCreateCubit,
        FormStatusData<RequestCategory>>(
      listener: (context, state) => requestCategoryStateListener(state),
      child: Builder(
        builder: (context) {
          final loading = context.select<RequestCategoryCreateCubit, bool>(
            (cubit) => cubit.state.maybeWhen(
              orElse: () => false,
              loading: () => true,
            ),
          );

          return Form(
            key: form,
            child: <Widget>[
              CustomTextFormField(
                key: RequestCategoryCreateForm.nameInputKey,
                labelText: 'Category Name',
                controller: name,
                textInputAction: TextInputAction.next,
                validator: (v) => InputValidator.required(v, 'Category name'),
              ),
              CustomTextFormField(
                key: RequestCategoryCreateForm.descriptionInputKey,
                labelText: 'Description',
                controller: description,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 25.h),
              MainButton(
                title: 'Submit',
                loading: loading,
                onTap: onSubmit,
              ),
            ].toColumn().padding(
                  horizontal: AppStyles.defaultPaddingHorizontal,
                  top: 15.h,
                ),
          );
        },
      ),
    );
  }

  void onSubmit() {
    if (!form.currentState.validate()) return;

    ConfirmationDialog(
      title: 'R U Sure?',
      content: 'Category name: ${name.text} \nDescription: ${description.text}'
          '\nThe requested category is cannot be changed.',
      onConfirm: submit,
    )..show(context);
  }

  void submit() {
    final dto = RequestCategoryCreateDto(
      name: name.text,
      description: description.text,
    );

    context.read<RequestCategoryCreateCubit>().submit(dto);
  }

  void requestCategoryStateListener(FormStatusData<RequestCategory> state) {
    state.maybeWhen(
      error: (e) =>
          CustomSnackbar.createError(message: e.message)..show(context),
      success: (_) => Navigator.of(context).pop(),
      orElse: () {},
    );
  }
}
