import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

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
                  const Center(child: AuthForm()),
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
