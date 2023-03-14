import 'package:chat_app/common/dialogs.dart';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  Future<void> _submitAuthForm({required String email, required String password, required String username, required bool isLogin}) async {
    late UserCredential userCredential;
    print("email: $email, password: $password, username: $username, isLogin $isLogin");
    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential.user?.email);
      }
    } catch(err, stacktrace) {
      print(stacktrace);
      showErrorDialog(context, err.toString());
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
        ]
      ),
    );
  }
}
