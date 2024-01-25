import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kenkyuu04/components/auth_modal/components/submit_button.dart';

import 'auth_text_form_field.dart';

class RegisttrationForm extends StatefulWidget {
  late Position position;
  RegisttrationForm(currentPosition, {
    super.key,
  }){
    position = currentPosition;
  }

  @override
  State<RegisttrationForm> createState() => _RegisttrationFormState(position);
}
class _RegisttrationFormState extends State<RegisttrationForm> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;
  bool _flagv = false;
  bool _flagd = false;

  late Position position;
  _RegisttrationFormState(currentPosition){
    position = currentPosition;
  }

  void _vending(bool? e) {
    setState(() {
      _flagv = e!;
    });
  }

  void _dust(bool? e) {
    setState(() {
      _flagd = e!;
    });
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _latitudeController.text = position.latitude.toString();
    _longitudeController.text = position.longitude.toString();
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
            labelText: position.latitude.toString(),
          ),
          const SizedBox(height: 16.0),
          AuthTextFormField(
            controller: _longitudeController,
            labelText: position.longitude.toString(),
          ),
          Center(
            child: Text('自動販売機'),
          ),
          Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.blue,
            value: _flagd,
            onChanged: _dust,
          ),
          Center(
            child: Text('ゴミ箱'),
          ),
          Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.blue,

            value: _flagv,
            onChanged: _vending,
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
      // 500ミリ秒待って、モーダルを閉じる
      await createPosition(

        latitude: _latitudeController.text,
        longitude: _longitudeController.text,
        vending: _flagv,
        dust: _flagd,
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
    required bool vending,
    required bool dust,
  }) async {
    await FirebaseFirestore.instance.collection('data').doc().set({
      'latitude': latitude,
      'longitude': longitude,
      'dust': vending,
      'vending': dust,
    });
  }
}