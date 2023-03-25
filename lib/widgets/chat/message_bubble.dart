import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageBubble extends StatelessWidget {
  final String? text;
  final String userId;
  final String username;
  const MessageBubble({this.text, required this.userId, required this.username, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUsers = userId == FirebaseAuth.instance.currentUser?.uid;

    return Row(
      mainAxisAlignment:
      isUsers ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isUsers)
          const Spacer(flex: 3,),
        if (!isUsers)
          Text(username),
        Flexible(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding:
            const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isUsers
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor),
            child: Text(
              text ?? "",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (!isUsers)
          const Spacer(flex: 3,),
      ],
    );
  }
}
