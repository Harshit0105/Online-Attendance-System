import 'package:E_Attendance/widgets/FacultyRegistrationForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFaculty extends StatefulWidget {
  static const routeName = "./AddFaculty";
  AddFaculty({Key key}) : super(key: key);

  @override
  _AddFacultyState createState() => _AddFacultyState();
}

class _AddFacultyState extends State<AddFaculty> {
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
      await app.delete();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Something went wrong.Please try again after some time."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addFaculty(
    String name,
    String email,
    String password,
    String birthDate,
    String mobile,
    String gender,
    String department,
    BuildContext ctx,
  ) async {
    setState(() {
      _isLoading = true;
    });

    // print(birthDate);
    User faculty = await register(email, password, ctx);
    FirebaseFirestore.instance.collection("users").doc(faculty.uid).set({
      "name": name,
      "dept": dept,
      'email': email,
      'role': "faculty",
    }).then((_) {
      print("user success!");
    });
    FirebaseFirestore.instance.collection("faculties").doc(faculty.uid).set({
      "name": name,
      "email": email,
      "dob": birthDate,
      "mobile": mobile,
      "dept": dept,
      'gender': gender,
      'role': "faculty",
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
        title: Text("New Faculty"),
      ),
      body: Container(
          child: FacultyRegistrationForm(
        submitFn: _addFaculty,
        isLoading: _isLoading,
        dept: dept,
      )),
    );
  }
}
