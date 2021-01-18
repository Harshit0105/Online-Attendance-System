import 'package:E_Attendance/model/Colors.dart';
import 'package:E_Attendance/screen/AddFaculty.dart';
import 'package:E_Attendance/screen/Showprof.dart';
import 'package:E_Attendance/screen/addStudent.dart';
import 'package:E_Attendance/screen/showStudents.dart';
import 'package:E_Attendance/screen/showFaculty.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/adminHomeListTile.dart';

class AdminHomeScreen extends StatefulWidget {
  static const routeName = "./AdminHomeScreen";
  AdminHomeScreen({Key key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    print(dept);
  }

  String dept;
  @override
  void didChangeDependencies() {
    dept = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  void _forward(String route, BuildContext context) {
    Navigator.of(context).pushNamed(route, arguments: dept);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dept + " Department" ?? "Admin",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 5,
        shadowColor: Colors.white,
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              print("User Profile");
              //Navigator.pushNamed(context, '/Showprof');
              Navigator.of(context).pushNamed(Showprof.routeName);

//              viewprofile();
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              logout();
            },
            color: Colors.black,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ListView(
          children: [
            SizedBox(
              height: 5,
            ),
            AdminHomeListTile(
              title: "View Faculties",
              forward: _forward,
              route: ShowFacultyScreen.routeName,
            ),
            Divider(),
            AdminHomeListTile(
              title: "View Students",
              forward: _forward,
              route: ShowStudentScreen.routeName,
            ),
            Divider(),
            AdminHomeListTile(
              title: "Add Student",
              forward: _forward,
              route: AddStudent.routeName,
            ),
            Divider(),
            AdminHomeListTile(
              title: "Add Faculty",
              forward: _forward,
              route: AddFaculty.routeName,
            ),
          ],
        ),
      ),
    );
  }
}
