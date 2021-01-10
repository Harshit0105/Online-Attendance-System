import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/AuthForm.dart';
import '../model/Colors.dart';
//AuthScreen
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _saveAuthForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      var message = 'An error occured,please check your credentials!';
      print(error);
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.grey,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(89, 84, 97, 0.58),
                Color.fromRGBO(147, 162, 171, 0.67)
              ]),
        ),
        child: AuthForm(
          _saveAuthForm,
          _isLoading,
        ),
      ),
    );
  }
}
