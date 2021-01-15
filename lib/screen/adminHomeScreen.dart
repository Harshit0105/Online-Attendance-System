import 'package:E_Attendance/model/Colors.dart';
import 'package:E_Attendance/screen/AddFaculty.dart';
import 'package:E_Attendance/screen/addStudent.dart';
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
        elevation: 3,
        backgroundColor: CustomeColors.skyBlue,
        actions: [
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
