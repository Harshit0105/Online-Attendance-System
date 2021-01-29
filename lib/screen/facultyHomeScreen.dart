import 'package:E_Attendance/model/Events.dart';
import 'package:E_Attendance/screen/AddEvent.dart';
import 'package:E_Attendance/screen/EventScreen.dart';
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
    super.initState();
  }

  // void disp() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   print("reached");
  //   final User usr = FirebaseAuth.instance.currentUser;
  //   await FirebaseFirestore.instance
  //       .collection("faculties")
  //       .doc(usr.uid)
  //       .get()
  //       .then((value) {
  //     //value.data()['events']
  //     Set<String> set = Set.from(value.data()['events']);
  //     set.forEach((element) => print(element));

  //     // dept = value.data()['dept'];
  //     //print("done");
  //   });
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final User usr = FirebaseAuth.instance.currentUser;
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("events")
              .where("facid", isEqualTo: usr.uid)
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDoc = snapshot.data.documents;
            if (chatDoc.length == 0) {
              return Center(
                child: Text(
                  "No events found",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5, right: 5),
              child: ListView.builder(
                itemCount: chatDoc.length,
                itemBuilder: (ctx, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          chatDoc[index]['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        chatDoc[index]['date'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                      ),
                      key: ValueKey(chatDoc[index].documentID),
                      onTap: () {
                        Events e = new Events(
                          batch: chatDoc[index]['batch'],
                          date: chatDoc[index]['date'],
                          desc: chatDoc[index]['description'],
                          id: chatDoc[index].documentID,
                          name: chatDoc[index]['name'],
                          sem: chatDoc[index]['sem'],
                        );
                        Navigator.of(context)
                            .pushNamed(EventScreen.routeName, arguments: e);
                      },
                    ),
                  ),
                ),
              ),
            );
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
