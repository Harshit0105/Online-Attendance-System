import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  static const routeName = "./AdminHomeScreen";
  AdminHomeScreen({Key key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home Screen"),
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
