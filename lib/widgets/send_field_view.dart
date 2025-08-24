import 'package:flutter/material.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/l10n/app_localizations.dart';

class SendFieldView extends StatelessWidget {
  const SendFieldView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        focusNode: Repository.to.sendFieldFocusNode,
        controller: Repository.to.sendFieldController,
        decoration: InputDecoration(hintText: l10n?.message ?? 'Message'),
        onSubmitted: (value) {
          Repository.to.sendMessage();
        },
      ),
    );
  }
}
