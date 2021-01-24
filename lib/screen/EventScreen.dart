import 'package:E_Attendance/screen/ScanScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/Events.dart';

class EventScreen extends StatefulWidget {
  static const routeName = "./EventScreen";
  EventScreen({Key key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  Events event;
  @override
  void didChangeDependencies() {
    event = ModalRoute.of(context).settings.arguments;
    print(event.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.name.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pushNamed(ScanScreen.routeName);
              print("QR Scanner");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Text("Name: "),
                  ),
                  Container(
                    child: Text(event.name),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    child: Text("Description: "),
                  ),
                  Container(
                    child: Text(event.desc),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    child: Text("Date: "),
                  ),
                  Container(
                    child: Text(event.date),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    child: Text("Semester: "),
                  ),
                  Container(
                    child: Text(event.sem),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    child: Text("Batch: "),
                  ),
                  Container(
                    child: Text(event.batch),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text("Students: "),
              ),
              SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("events")
                      .doc(event.id)
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final doc = snapshot.data;
                    final students = Map<String, bool>.from(doc["students"]);
                    final keys = List<String>.from(students.keys);
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: students.length,
                      itemBuilder: (context, index) => StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("students")
                            .doc(keys[index])
                            .snapshots(),
                        builder: (ctx, stSnapShot) {
                          if (stSnapShot.connectionState ==
                                  ConnectionState.waiting ||
                              !stSnapShot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final stu = stSnapShot.data;
                          return Container(
                            child: Text(
                              stu["name"],
                              style: TextStyle(
                                color: students[keys[index]] == false
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
