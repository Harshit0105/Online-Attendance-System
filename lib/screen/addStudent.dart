import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/StudentRegistrationForm.dart';

class AddStudent extends StatefulWidget {
  static const routeName = "./AddStudent";
  AddStudent({Key key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  bool _isLoading = false;
  String dept;
  @override
  void didChangeDependencies() {
    dept = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  static Future<User> register(
      String email, String password, BuildContext context) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      print("usr done");
      final User user = FirebaseAuth.instanceFor(app: app).currentUser;
      await app.delete();
      return Future.sync(() => user);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Something went wrong.Please try again after some time."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addStudent(
    String name,
    String id,
    String birthDate,
    String gender,
    String department,
    String mobile,
    String sem,
    String batch,
    BuildContext ctx,
  ) async {
    setState(() {
      _isLoading = true;
    });
    String email = id + "@ddu.com";
    // print(birthDate);
    User stu = await register(email, birthDate, ctx);
    FirebaseFirestore.instance.collection("users").doc(stu.uid).set({
      "name": name,
      "dept": dept,
      'email': email,
      'role': "student",
    }).then((_) {
      print("user success!");
    });
    FirebaseFirestore.instance.collection("students").doc(stu.uid).set({
      "name": name,
      "id": id,
      "mobile": mobile,
      "dob": birthDate,
      "dept": dept,
      'gender': gender,
      'sem': sem,
      'batch': batch,
      'role': "student",
    }).then((_) {
      print("success!");
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
    return Scaffold(
      appBar: AppBar(
        title: Text("New Student"),
      ),
      body: StudentRegistrationForm(
        submitFn: _addStudent,
        isLoading: _isLoading,
        dept: dept,
      ),
    );
  }
}
