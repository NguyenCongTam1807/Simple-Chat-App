import 'package:firebase_messaging/firebase_messaging.dart';
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
      body: FutureBuilder(
        future: FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        ),
        builder: (BuildContext context,
            AsyncSnapshot<NotificationSettings> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data?.authorizationStatus ==
              AuthorizationStatus.authorized) {
            return Column(
              children: const [
                Expanded(child: Messages()),
                NewMessage(),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
