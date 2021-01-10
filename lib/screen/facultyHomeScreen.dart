import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FacultyHomeScreen extends StatefulWidget {
  static const routeName = "./FacultyHomeScreen";
  FacultyHomeScreen({Key key}) : super(key: key);

  @override
  _FacultyHomeScreenState createState() => _FacultyHomeScreenState();
}

class _FacultyHomeScreenState extends State<FacultyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculty Home Screen"),
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
