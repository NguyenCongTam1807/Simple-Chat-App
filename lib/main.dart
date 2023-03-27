import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.amber,
          accentColor: Colors.purple,
          buttonTheme: const ButtonThemeData().copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
      home: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser?.uid ?? "")
                  .get()
                  .then((value) {
                return value.data()?['username'];
              }),
              builder: (BuildContext context, AsyncSnapshot<dynamic> futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ChatScreen(futureSnapshot.data);
              },
            );
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
