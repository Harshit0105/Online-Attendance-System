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
  bool isLoading;
  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    print(dept);
  }

  String dept;

  @override
  void initState() {
    // TODO: implement initState
    isLoading = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    dept = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  void _forward(String route, BuildContext context) {
    Navigator.of(context).pushNamed(route, arguments: dept);
  }

  void showIncreaseSemesterDialogBox() {
    var dialog = new AlertDialog(
      title: new Text("Are you sure!!"),
      content: Text(
          "This will increase semster by one for each students.\nDo you want to increase?"),
      actions: <Widget>[
        new FlatButton(
          child: Text("cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
            color: Colors.green,
            child: Text("Yes"),
            onPressed: () {
              increase(dept, context);
              Navigator.of(context).pop();
            }),
      ],
    );

    showDialog(context: context, child: dialog);
  }

  void showDecreaseSemesterDialogBox() {
    var dialog = new AlertDialog(
      title: new Text("Are you sure!!"),
      content: Text(
          "This will decrease semster by one for each students.\nDo you want to decrease?"),
      actions: <Widget>[
        new FlatButton(
          child: Text("cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
            color: Colors.green,
            child: Text("Yes"),
            onPressed: () {
              decrease(dept, context);
              Navigator.of(context).pop();
            }),
      ],
    );

    showDialog(context: context, child: dialog);
  }

  void increase(String dept, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("students")
        // ignore: deprecated_member_use
        .where("dept", isEqualTo: dept)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection("students")
            .doc(element.id)
            .update({"sem": FieldValue.increment(1)});
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  void decrease(String dept, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("students")
        // ignore: deprecated_member_use
        .where("dept", isEqualTo: dept)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection("students")
            .doc(element.id)
            .update({"sem": FieldValue.increment(-1)});
      });
    });
    setState(() {
      isLoading = false;
    });
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
              Navigator.of(context).pushNamed(Showprof.routeName);
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
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
                  Divider(),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Increase Semester",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        print("Tile Pressed!!");
                        showIncreaseSemesterDialogBox();
                        // pressed(context);
                      },
                    ),
                  ),
                  Divider(),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "Decrease Semester",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        print("Tile Pressed!!");
                        showDecreaseSemesterDialogBox();
                        // pressed(context);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
