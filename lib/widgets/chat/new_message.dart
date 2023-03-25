import 'package:chat_app/common/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        final userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        FirebaseFirestore.instance.collection('chat').add({
          'text': _messageController.text,
          'userId': FirebaseAuth.instance.currentUser?.uid,
          'username': userData['username'],
          'createdAt':
              DateFormat('yyyy-MM-dd, hh:mm:ss.SSS').format(DateTime.now())
        });
        if (mounted) {
          FocusScope.of(context).unfocus();
        }
        _messageController.text = '';
      } catch (err, stacktrace) {
        print(stacktrace);
        showErrorDialog(context, err.toString());
      }
    }
  }

  Future<void> _pickPhoto() async {}

  String _enteredMessage = '';
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.photo,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _pickPhoto,
          ),
          Expanded(
              child: TextField(
            decoration: const InputDecoration(labelText: "Type a message"),
            controller: _messageController,
          )),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
