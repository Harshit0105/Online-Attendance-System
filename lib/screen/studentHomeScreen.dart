import 'package:E_Attendance/main.dart';
import 'package:E_Attendance/model/Events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentHomeScreen extends StatefulWidget {
  static const routeName = "./StudentHomeScreen";
  StudentHomeScreen({Key key}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
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
  Widget build(BuildContext context) {
    final User usr = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Student Home Screen"),
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
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("students")
              .doc(usr.uid)
              .get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<String> students = new List.from(snapshot.data["events"]);
            print(students);
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("events")
                        .doc(students[index])
                        .snapshots(),
                    builder: (ctx, eventdata) {
                      if (!eventdata.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      print(eventdata);
                      var e = eventdata.data;
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            e["name"],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          e['date'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            letterSpacing: 1,
                          ),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.more_vert_outlined),
                            onPressed: () {
                              var dialog = new AlertDialog(
                                title: new Text(e['name']),
                                content: Text(
                                  e['description'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    letterSpacing: 1,
                                  ),
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: Text("Done"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );

                              showDialog(context: context, child: dialog);
                            }),
                      );
                    });
              },
            );
          }),
    );
  }
}
