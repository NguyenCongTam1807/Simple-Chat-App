import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  final String username;

  const ChatScreen(this.username, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: const [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
    );
  }
}
