import 'package:flutter/material.dart';

class AddFaculty extends StatefulWidget {
  static const routeName = "./AddFaculty";
  AddFaculty({Key key}) : super(key: key);

  @override
  _AddFacultyState createState() => _AddFacultyState();
}

class _AddFacultyState extends State<AddFaculty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Center(
        child: Text("Add Faculty"),
      )),
    );
  }
}
