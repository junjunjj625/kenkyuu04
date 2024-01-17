import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kenkyuu04/components/auth_modal/components/submit_button.dart';

import 'auth_text_form_field.dart';


class search extends StatefulWidget {
  const search({
    super.key,
  });

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
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

  String? validatelatitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? validatelongitude(String? value) {
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
        children: [
          const Text(
            '検索',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          AuthTextFormField(
            controller: _latitudeController,
            validator: validatelatitude,
            labelText: '緯度',
          ),
          const SizedBox(height: 16.0),
          AuthTextFormField(
            controller: _longitudeController,
            validator: validatelongitude,
            labelText: '経度',
          ),
          const SizedBox(height: 16.0),
          SubmitButton(
            labelName: '検索',
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