import 'package:E_Attendance/screen/AddFaculty.dart';
import 'package:E_Attendance/screen/addStudent.dart';
import 'package:E_Attendance/screen/showStudents.dart';
import 'package:E_Attendance/screen/showFaculty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:E_Attendance/screen/adminHomeScreen.dart';
import 'package:E_Attendance/screen/dummy.dart';
import 'package:E_Attendance/screen/facultyHomeScreen.dart';
import 'package:E_Attendance/screen/studentHomeScreen.dart';

import './screen/authScreen.dart';
import './screen/adminHomeScreen.dart';
// ignore: unused_import
import './screen/Showprof.dart';

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
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: "YuseiMagic",
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
      routes: {
        AdminHomeScreen.routeName: (ctx) => AdminHomeScreen(),
        StudentHomeScreen.routeName: (ctx) => StudentHomeScreen(),
        FacultyHomeScreen.routeName: (ctx) => FacultyHomeScreen(),
        AddStudent.routeName: (ctx) => AddStudent(),
        AddFaculty.routeName: (ctx) => AddFaculty(),
        ShowStudentScreen.routeName: (ctx) => ShowStudentScreen(),
        ShowFacultyScreen.routeName: (ctx) => ShowFacultyScreen(),
        HomePage.routeName: (ctx) => HomePage(),
        Showprof.routeName: (ctx) => Showprof(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  static const routeName = "./HomePage";
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
          final User user = FirebaseAuth.instance.currentUser;
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get()
              .then((value) {
            // print(user.uid);
            if (value.data()['role'] == "admin") {
              print(value.data()['role']);
              // return AdminHomeScreen();
              Navigator.of(context).pushReplacementNamed(
                AdminHomeScreen.routeName,
                arguments: value.data()['dept'],
              );
            } else if (value.data()['role'] == "faculty") {
              print(value.data()['role']);
              // return FacultyHomeScreen();
              Navigator.of(context).pushReplacementNamed(
                FacultyHomeScreen.routeName,
                arguments: value.data()['dept'],
              );
            } else if (value.data()['role'] == "student") {
              print(value.data()['role']);
              // return StudentHomeScreen();
              Navigator.of(context).pushReplacementNamed(
                StudentHomeScreen.routeName,
                arguments: value.data()['dept'],
              );
            } else {
              return Dummy();
            }
          });
        }
        return AuthScreen();
      },
    );
  }
}
