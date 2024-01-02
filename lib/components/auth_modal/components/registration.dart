import 'package:flutter/cupertino.dart';
import 'package:kenkyuu04/components/auth_modal/components/submit_button.dart';

import 'auth_text_form_field.dart';

class registtration extends StatefulWidget {
  const registtration({
    super.key,
  });

  @override
  State<registtration> createState() => _registtrationState();
}

class _registtrationState extends State<registtration> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  // ---------  Validation ---------

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          AuthTextFormField(
            controller: _latitudeController,
            validator: validateEmail,
            labelText: 'Email',
          ),
          const SizedBox(height: 16.0),
          AuthTextFormField(
            controller: _longitudeController,
            obscureText: true,
            validator: validatePassword,
            labelText: 'Password',
          ),
          const SizedBox(height: 16.0),
          SubmitButton(
            labelName: '新規登録',
            onTap: () => _submit(context),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {}
  }
}