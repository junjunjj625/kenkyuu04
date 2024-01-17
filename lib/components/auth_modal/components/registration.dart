import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kenkyuu04/components/auth_modal/components/submit_button.dart';

import 'auth_text_form_field.dart';

class RegisttrationForm extends StatefulWidget {
  const RegisttrationForm({
    super.key,
  });

  @override
  State<RegisttrationForm> createState() => _RegisttrationFormState();
}

class _RegisttrationFormState extends State<RegisttrationForm> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  // ---------  Validation ---------

  /*String? validateEmail(String? value) {
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
  }*/





  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '新規登録',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          AuthTextFormField(
            controller: _latitudeController,
            //validator: validateEmail,
            labelText: '緯度',
          ),
          const SizedBox(height: 16.0),
          AuthTextFormField(
            controller: _longitudeController,
            //validator: validatePassword,
            labelText: '経度',
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
    if (_formKey.currentState!.validate()) {
      /*// サインアップ処理
      final UserCredential? user = await registtration(
        latitude: _latitudeController.text,
        longitude: _longitudeController.text,
      );*/

      // 500ミリ秒待って、モーダルを閉じる
      await createPosition(
        latitude: _latitudeController.text,
        longitude: _longitudeController.text,
      );
      if (!mounted) return;
      Future.delayed(
        const Duration(milliseconds: 500),
        Navigator.of(context).pop,
      );
    }
  }
  Future<void> createPosition({
    required String latitude,
    required String longitude,
  }) async {
    await FirebaseFirestore.instance.collection('data').doc().set({
      'latitude': latitude,
      'longitude': longitude,
      'dust': true,
      'vending': true,
    });
  }
}