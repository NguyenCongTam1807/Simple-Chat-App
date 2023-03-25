import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .where('text', isNotEqualTo: null)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final documents = snapshot.data?.docs;
          return ListView.builder(
              reverse: true,
              itemCount: documents?.length,
              itemBuilder: (ctx, index) {
                final messageData = documents?[index].data();
                return MessageBubble(
                  text: messageData?['text'],
                  userId: messageData?['userId']??"",
                  username: messageData?['username']??"",
                  key: ValueKey(documents?[index].id),
                );
              });
        }
      },
    );
  }
}
