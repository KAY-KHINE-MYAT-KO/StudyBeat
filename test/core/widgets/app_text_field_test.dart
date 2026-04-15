import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studybeat/core/widgets/app_text_field.dart';

void main() {
  testWidgets('AppTextField shows and clears validation error based on user input', (
    WidgetTester tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    formKey.currentState!.validate();
                  },
                  child: const Text('Validate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Validate'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'test@example.com');
    await tester.tap(find.text('Validate'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsNothing);
  });
}
