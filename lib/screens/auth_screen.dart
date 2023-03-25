import 'package:chat_app/common/dialogs.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  bool isLoading = false;

  Future<void> _submitAuthForm({required String email, required String password, required String username, required bool isLogin}) async {
    late UserCredential userCredential;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
          'username' : username,
          'email': email,
        });
      }
    } catch(err, stacktrace) {
      print(stacktrace);
      showErrorDialog(context, err.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(253, 190, 91, 0.7),
                  Color.fromRGBO(217, 42, 126, 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("MESSENGER", style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                  ),),
                  Icon(Icons.send, size: 48, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 30,),
                  Center(child: AuthForm(_submitAuthForm)),
                  const SizedBox(height: 60,),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.5),
                alignment: AlignmentDirectional.center,child: const CircularProgressIndicator()),
        ]
      ),
    );
  }
}
