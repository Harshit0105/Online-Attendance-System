import 'package:E_Attendance/widgets/AddEventForm.dart';
import 'package:E_Attendance/widgets/FacultyRegistrationForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
  static const routeName = "/addevent";
}

class _AddEventScreenState extends State<AddEventScreen> {
  bool _isLoading = false;
  String dept;
  @override
  void didChangeDependencies() {
    dept = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  void _addEvent(
    String name,
    String facid,
    //String email,
    List<String> students,
    String department,
    BuildContext ctx,
  ) async {
    setState(() {
      _isLoading = true;
    });
    var z = new Map<String, bool>();

    for (var i = 0; i <= students.length; i++) {
      z[students[i]] = false;
    }
    // print(birthDate);
    //User faculty = await register(email, birthDate, ctx);
    FirebaseFirestore.instance.collection("events").add({
      "name": name,
      "facid": facid,
      //"email": email,
      "dept": department,
      "students": z,
    });

    setState(() {
      _isLoading = false;
    });
    Scaffold.of(ctx).showSnackBar(
      SnackBar(content: Text("Done")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AddEventForm(isLoading: _isLoading, dept: dept);
  }
}
