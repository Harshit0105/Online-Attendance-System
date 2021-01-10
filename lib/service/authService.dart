//Auth Service
import 'package:E_Attendance/screen/adminHomeScreen.dart';
import 'package:E_Attendance/screen/authScreen.dart';
import 'package:E_Attendance/screen/dummy.dart';
import 'package:E_Attendance/screen/facultyHomeScreen.dart';
import 'package:E_Attendance/screen/studentHomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  Widget handleAuth() {
    return new StreamBuilder(
      // ignore: deprecated_member_use
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, userSnapShot) {
        if (userSnapShot.hasData) {
          authorizeAccess(ctx);
        }
        return AuthScreen();
      },
    );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  authorizeAccess(BuildContext context) async {}
}
