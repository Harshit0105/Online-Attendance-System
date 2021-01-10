import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import './screen/authScreen.dart';
import './screen/dummy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "PottaOne",
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (contax, snapshot) {
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // ignore: deprecated_member_use
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, userSnapShot) {
        if (userSnapShot.hasData) {
          return Dummy();
        }
        return AuthScreen();
      },
    );
  }
}
