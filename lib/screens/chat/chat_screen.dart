import 'package:flutter/material.dart';
import 'package:couleur/screens/chat/chat_layouts/chat_large_layout.dart';
import 'package:couleur/screens/chat/chat_layouts/chat_small_layout.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return ChatLargeLayout();
        }
        return ChatSmallLayout();
      },
    );
  }
}
