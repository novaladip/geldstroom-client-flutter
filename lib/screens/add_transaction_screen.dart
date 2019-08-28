import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geldstroom/models/post_transaction_body.dart';
import 'package:geldstroom/provider/overviews.dart';
import 'package:geldstroom/provider/records.dart';
import 'package:geldstroom/utils/validate_input.dart';
import 'package:geldstroom/widgets/shared/choice_chip_category.dart';
import 'package:geldstroom/widgets/shared/choice_chip_type.dart';
import 'package:geldstroom/widgets/shared/quotes.dart';
import 'package:geldstroom/widgets/shared/text_input.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  static final routeName = '/add-transaction';

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  var _category = 'FOOD';
  var _type = 'EXPENSE';
  var _isLoading = false;
  final _form = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionFocusNode = FocusNode();

  Future<void> _onSubmit() async {
    try {
      setState(() => _isLoading = true);
      final isValid = _form.currentState.validate();

      if (!isValid) return;

      await Provider.of<Records>(context, listen: false).postTransaction(
        PostTransactionBody(
          type: _type,
          category: _category,
          description: _descriptionController.text,
          amount: int.parse(_amountController.text),
        ),
      );
      Provider.of<Overviews>(context, listen: false)
        ..fetchBalance()
        ..fetchTransactions();
      Navigator.of(context).pop();
    } catch (error) {
      setState(() => _isLoading = false);
      throw error;
    }
  }

  Widget _loadingIndicator() => SpinKitDualRing(
        lineWidth: 14,
        color: Colors.white,
        size: 14,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                Quotes(
                  quote:
                      '"Nothing is more expensive than a free government service." - Jeffrey Tucker',
                ),
                ChoiceChipType(
                  selectedType: _type,
                  onSelected: (type) => setState(() => _type = type),
                ),
                ChoiceChipCategory(
                  selectedCategory: _category,
                  onSelected: (category) =>
                      setState(() => _category = category),
                ),
                TextInput(
                  textEditingController: _amountController,
                  labelText: 'Amount',
                  icon: Icon(Icons.attach_money),
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: () => _descriptionFocusNode.requestFocus(),
                  validator: validateAmount,
                ),
                TextInput(
                  textEditingController: _descriptionController,
                  labelText: 'Description',
                  icon: Icon(Icons.description),
                  focusNode: _descriptionFocusNode,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: validateDescription,
                  onFieldSubmitted: () {
                    if (_amountController.text.isNotEmpty) {
                      _onSubmit();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ButtonTheme(
                    textTheme: ButtonTextTheme.primary,
                    buttonColor: Theme.of(context).primaryColor,
                    minWidth: double.infinity,
                    child: RaisedButton(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child:
                            _isLoading ? _loadingIndicator() : Text('SUBMIT'),
                      ),
                      onPressed: _onSubmit,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }
}
