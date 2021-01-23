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
    String desc,
    String date,
    String sem,
    String batch,
    BuildContext ctx,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<String> students = new List<String>();
      List<bool> eventValue = new List<bool>();
      print(name);
      if (batch == "ALL") {
        await FirebaseFirestore.instance
            .collection('students')
            .where("dept", isEqualTo: dept)
            .where("sem", isEqualTo: int.parse(sem))
            .orderBy("name", descending: false)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            students.add(element.id);
            eventValue.add(false);
          });
        });
      } else {
        await FirebaseFirestore.instance
            .collection('students')
            .where("dept", isEqualTo: dept)
            .where("sem", isEqualTo: int.parse(sem))
            .where("batch", isEqualTo: batch)
            .orderBy("name", descending: false)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            students.add(element.id);
            eventValue.add(false);
          });
        });
      }
      Map<String, bool> z = Map.fromIterables(students, eventValue);
      final fac = FirebaseAuth.instance.currentUser;
      // print(fac);
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection("events").add({
        "name": name,
        "description": desc,
        "facid": fac.uid,
        "dept": dept,
        "sem": sem,
        "batch": batch,
        "students": z,
      });
      final studentref = FirebaseFirestore.instance.collection("students");
      final eventId = [docRef.id];
      await FirebaseFirestore.instance
          .collection("faculties")
          .doc(fac.uid)
          .update({
        'events': FieldValue.arrayUnion(eventId),
      });
      students.forEach((element) async {
        await studentref.doc(element).update({
          'events': FieldValue.arrayUnion(eventId),
        });
      });
    } catch (erro) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text("Something went wrong try after some time!!"),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
    Scaffold.of(ctx).showSnackBar(
      SnackBar(content: Text("Done")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Event"),
      ),
      body: AddEventForm(
        submitFn: _addEvent,
        isLoading: _isLoading,
        dept: dept,
      ),
    );
  }
}
