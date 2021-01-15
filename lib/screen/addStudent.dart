import 'package:flutter/material.dart';

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

  void _addStudent(
    String name,
    String id,
    String birthDate,
    String gender,
    String department,
    String sem,
    String batch,
    BuildContext ctx,
  ) async {
    print(name);
    print(id);
    print(birthDate);
    print(gender);
    print(department);
    print(sem);
    print(batch);
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
