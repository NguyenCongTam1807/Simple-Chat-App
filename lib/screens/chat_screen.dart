import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat/mvKm3XoySd1ZZuAha1dX/messages')
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final documents = snapshot.data?.docs;
            documents?.sort((a, b) => a['createdAt'].compareTo(b['createdAt']));

            return ListView.builder(
                itemCount: documents?.length,
                itemBuilder: (ctx, index) {
                  return Text('${documents?[index]['text']}');
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final time = DateFormat('yyyy-MM-dd, hh:mm:ss.SSS').format(DateTime.now());
          FirebaseFirestore.instance
              .collection('chat/mvKm3XoySd1ZZuAha1dX/messages')
              .add({
            'text': "Text: $time",
            'createdAt': time
          });
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
