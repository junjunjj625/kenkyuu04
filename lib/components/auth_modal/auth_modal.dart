import 'package:kenkyuu04/components/auth_modal/components/close_modal_button.dart';
import 'package:flutter/material.dart';

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
  String buttonLabel = '登録へ';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          const CloseModalButton(),
          modalType == AuthModalType.search
              ? const Text('検索')
              : const Text('登録'),
          TextButton(
            onPressed: switchModalType,
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }

  void switchModalType() {
    setState(() {
      modalType = modalType == AuthModalType.search
          ? AuthModalType.registration
          : AuthModalType.search;

      buttonLabel = modalType == AuthModalType.search ? '登録へ' : '検索へ';
    });
  }
}