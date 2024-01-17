import 'package:kenkyuu04/components/auth_modal/components/close_modal_button.dart';
import 'package:flutter/material.dart';

import 'components/registration.dart';
import 'components/search.dart';

enum AuthModalType {
  search,
  registration;
}

class AuthModal extends StatefulWidget {
  const AuthModal({super.key});

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  AuthModalType modalType = AuthModalType.search;
  String buttonLabel = '検索へ';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => unFocus(context),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      height: MediaQuery.of(context).size.height * 0.9,
    child: SingleChildScrollView(
      child: Column(
        children: [
          const CloseModalButton(),
          modalType == AuthModalType.search
              //? const Text('検索')
              //: const Text('登録'),
              ? const RegisttrationForm()
              : const search(),
          TextButton(
            onPressed: switchModalType,
            child: Text(buttonLabel),
          ),
          const SizedBox(height: 300)
        ],
      ),
    ),
    ),
    );
  }

  void unFocus(BuildContext context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
  void switchModalType() {
    setState(() {
      modalType = modalType == AuthModalType.search
          ? AuthModalType.registration
          : AuthModalType.search;

      buttonLabel = modalType == AuthModalType.search ? '検索へ' : '登録へ';
    });
  }
}