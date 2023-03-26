import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageBubble extends StatelessWidget {
  final String? text;
  final String userId;
  final String? imageUrl;
  const MessageBubble(
      {this.text, required this.userId, this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUsers = userId == FirebaseAuth.instance.currentUser?.uid;

    return Row(
      mainAxisAlignment:
          isUsers ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isUsers)
          const Spacer(
            flex: 3,
          ),
        if (!isUsers && imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: CircleAvatar(
                radius: 12, backgroundImage: NetworkImage(imageUrl!)),
          ),
        Flexible(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
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
          const Spacer(
            flex: 3,
          ),
      ],
    );
  }
}
