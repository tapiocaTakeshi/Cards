import 'package:cards/HomePage.dart';

import 'package:cards/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cards',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              scrolledUnderElevation: 0,
              elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.deepPurple)),
            scaffoldBackgroundColor: Colors.deepPurple.shade100,
            listTileTheme: ListTileThemeData(
                tileColor: Colors.white,
                titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                subtitleTextStyle:
                    TextStyle(fontSize: 10, color: Colors.black)),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
        routes: {
          '/sign-in': (context) => SignInScreen(
                providers: [EmailAuthProvider()],
                actions: [
                  AuthStateChangeAction<SignedIn>((context, state) async{
                    await Navigator.of(context).pushReplacementNamed('/home');
                  }),
                  AuthStateChangeAction<UserCreated>((context, state) async {
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({});
                        await Navigator.of(context).pushReplacementNamed('/home');
                  })
                ],
              ),
          '/home': (context) => HomePage()
        });
  }
}
