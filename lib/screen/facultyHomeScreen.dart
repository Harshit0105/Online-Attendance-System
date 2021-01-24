import 'package:E_Attendance/screen/AddEvent.dart';
import 'package:E_Attendance/screen/EventScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import '../model/Events.dart';

class FacultyHomeScreen extends StatefulWidget {
  static const routeName = "./FacultyHomeScreen";
  FacultyHomeScreen({Key key}) : super(key: key);

  @override
  _FacultyHomeScreenState createState() => _FacultyHomeScreenState();
}

class _FacultyHomeScreenState extends State<FacultyHomeScreen> {
  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    print(dept);
  }

  String dept;
  List<Events> events;
  User usr;
  @override
  void didChangeDependencies() {
    dept = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    usr = FirebaseAuth.instance.currentUser;
    super.initState();
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where("facid", isEqualTo: usr.uid)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapShot) {
          if (chatSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final eventDoc = chatSnapShot.data.documents;
          return ListView.builder(
            itemCount: eventDoc.length,
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 2,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text(
                    eventDoc[index]['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  subtitle: Text(
                    eventDoc[index]['date'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(EventScreen.routeName,
                        arguments: new Events(
                          id: eventDoc[index].documentID,
                          name: eventDoc[index]['name'],
                          desc: eventDoc[index]['description'],
                          batch: eventDoc[index]['batch'],
                          date: eventDoc[index]['date'],
                          sem: eventDoc[index]['sem'],
                        ));
                  },
                  key: ValueKey(eventDoc[index].documentID),
                ),
              ),
            ),
          );
        },
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
