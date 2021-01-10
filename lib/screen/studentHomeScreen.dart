import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentHomeScreen extends StatefulWidget {
  static const routeName = "./StudentHomeScreen";
  StudentHomeScreen({Key key}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Home Screen"),
      ),
      body: Container(
        child: FlatButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Center(child: Text("Logout"))),
      ),
    );
  }
}
