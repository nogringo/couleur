import 'package:flutter/material.dart';
import 'package:couleur/repository.dart';

class SendFieldView extends StatelessWidget {
  const SendFieldView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        focusNode: Repository.to.sendFieldFocusNode,
        controller: Repository.to.sendFieldController,
        decoration: InputDecoration(hintText: "Message"),
        onSubmitted: (value) {
          Repository.to.sendMessage();
        },
      ),
    );
  }
}
