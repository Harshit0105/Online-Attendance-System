import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/AuthForm.dart';

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ///////
              Color(0xff0F2027),
              Color(0xff203A43),
              Color(0xff2C5364),
              //////
              // Color(0xff4B79A1),
              // Color(0xff283E51),
              //////
              // Color(0xff616161),
              // Color(0xff9bc5c3),
            ],
          ),
        ),
        child: AuthForm(
          _saveAuthForm,
          _isLoading,
        ),
      ),
    );
  }
}
