import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_otp/flutter_otp.dart';
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
  String eventName = "";
  String studentName = "";
  String studentId = "";
  bool error = false;

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
          title: Text(this.eventName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(this.studentName),
              ],
            ),
          ),
          actions: <Widget>[
            if (!error)
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("events")
                      .doc(event.id)
                      .update({
                    "students.${this.studentId}": true,
                  }).then((_) => print("Updated"));
                  Navigator.of(context).pop();
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

  // void otpAlertBox() {
  //   var otpText = "";

  //   var dialog = new AlertDialog(
  //     title: new Text("Update student"),
  //     content: StatefulBuilder(
  //       builder: (BuildContext context, StateSetter setState) => Container(
  //         child: new TextField(
  //           keyboardType: TextInputType.number,
  //           maxLength: 4,
  //           onChanged: (value) {
  //             otpText = value;
  //           },
  //         ),
  //       ),
  //     ),
  //     actions: <Widget>[
  //       new FlatButton(
  //         minWidth: 100,
  //         color: Colors.green,
  //         child: Text("Done"),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //       new FlatButton(
  //         minWidth: 100,
  //         color: Colors.red,
  //         child: Text("Cancle"),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //     ],
  //   );
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext ctx) => dialog,
  //   );
  // }

  Future scan() async {
    try {
      error = false;
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      if (barcode != "-1") {
        _showMyDialog();
      }
      if (barcode.startsWith("DDUAttendanceSystem")) {
        final barcodeList = barcode.split(";");
        print(barcodeList);
        if (event.id == barcodeList[1]) {
          String eventName = barcodeList[3];
          String studentName = barcodeList[4];
          setState(() {
            this.eventName = eventName;
            this.studentName = studentName;
            this.studentId = barcodeList[2];
          });
        } else {
          setState(() {
            this.error = true;
            this.eventName = "Please provide valid QR code";
            this.studentName = "This qr code is not for this event!!";
          });
        }
      } else {
        setState(() {
          this.error = true;
          this.eventName = "Please provide valid QR code";
          this.studentName = "";
        });
      }
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
      backgroundColor: Colors.grey,
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 5,
                      right: 8,
                      left: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "Name: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            event.name,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Description: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Expanded(
                            child: Text(
                              event.desc,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              maxLines: 10,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "Date: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            event.date,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "Semester: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            event.sem,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "Batch: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            event.batch,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                ],
              ),
            ),
            ListTile(
              title: Card(
                // color: Colors.black87,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Students ",
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("events")
                          .doc(event.id)
                          .snapshots(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final doc = snapshot.data;
                        final students =
                            Map<String, bool>.from(doc["students"]);
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
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  title: Text(
                                    stu["name"].toString().toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: students[keys[index]] == false
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                  // trailing: IconButton(
                                  //   icon: Icon(Icons.send),
                                  //   color: students[keys[index]] == false
                                  //       ? Colors.black
                                  //       : Colors.grey,
                                  //   onPressed: students[keys[index]] == false
                                  //       ? () {
                                  //           otpAlertBox();
                                  //         }
                                  //       : () {},
                                  // ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
