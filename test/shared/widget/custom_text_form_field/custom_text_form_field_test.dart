import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/shared/widget/custom_text_form_field/custom_text_form_field.dart';

import '../../../test_helper.dart';

class Home extends StatelessWidget {
  final emailController = TextEditingController();

  Home({
    Key key,
    @required this.labelText,
    @required this.textInputKey,
    @required this.onFieldSubmitted,
  }) : super(key: key);

  final String labelText;
  final Key textInputKey;
  final VoidCallback onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomTextFormField(
        labelText: labelText,
        controller: emailController,
        key: textInputKey,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}

void main() {
  testWidgets('TextInput, should render correctly', (tester) async {
    var isSubmitted = false;
    final textInputKey = UniqueKey();
    final labelText = 'Email';

    final expectedInputValue = 'some@email.com';
    final subject = buildTestableWidget(Home(
      labelText: labelText,
      textInputKey: textInputKey,
      onFieldSubmitted: () => isSubmitted = true,
    ));

    await tester.pumpWidget(subject);

    expect(isSubmitted, false);
    expect(find.text(labelText), findsOneWidget);
    expect(find.byKey(textInputKey), findsOneWidget);
    expect(find.text(expectedInputValue), findsNothing);

    // simulate user input
    await tester.enterText(find.byKey(textInputKey), expectedInputValue);
    // simulate sending action keyboard event
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text(expectedInputValue), findsOneWidget);
    expect(isSubmitted, true);
  });
}
