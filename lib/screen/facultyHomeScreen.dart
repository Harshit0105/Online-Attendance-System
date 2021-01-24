import 'package:E_Attendance/screen/AddEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class FacultyHomeScreen extends StatefulWidget {
  static const routeName = "./FacultyHomeScreen";
  FacultyHomeScreen({Key key}) : super(key: key);

  @override
  _FacultyHomeScreenState createState() => _FacultyHomeScreenState();
}

class _FacultyHomeScreenState extends State<FacultyHomeScreen> {
  bool _isLoading = false;
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

  @override
  void initState() {
    _isLoading = false;

    // TODO: implement initState
    disp();
    super.initState();
  }

  void disp() async {
    setState(() {
      _isLoading = true;
    });
    print("reached");
    final User usr = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("faculties")
        .doc(usr.uid)
        .get()
        .then((value) {
      //value.data()['events']
      Set<String> set = Set.from(value.data()['events']);
      set.forEach((element) => print(element));

      // dept = value.data()['dept'];
      //print("done");
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculty Home Screen"),
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
      body: Container(
        child: FlatButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          print("done");
          Navigator.of(context)
              .pushNamed(AddEventScreen.routeName, arguments: dept);
        },
      ),
    );
  }
}
