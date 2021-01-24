import 'package:E_Attendance/screen/ScanScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

import '../model/Events.dart';

class EventScreen extends StatefulWidget {
  static const routeName = "./EventScreen";
  EventScreen({Key key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String barcode = "";

  Events event;
  @override
  void didChangeDependencies() {
    event = ModalRoute.of(context).settings.arguments;
    print(event.id);
    super.didChangeDependencies();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(barcode),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                print(barcode);
                //Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: new TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future scan() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      _showMyDialog();
      print(barcode);
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
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
            onPressed: () async {
              scan();
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
