import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dummy extends StatelessWidget {
  const Dummy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FlatButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text("Logout")),
      ),
    );
  }
}
