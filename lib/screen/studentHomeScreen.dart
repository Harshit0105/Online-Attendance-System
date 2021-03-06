import 'package:E_Attendance/main.dart';
import 'package:E_Attendance/model/Events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentHomeScreen extends StatefulWidget {
  static const routeName = "./StudentHomeScreen";
  StudentHomeScreen({Key key}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  GlobalKey globalKey = new GlobalKey();

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

  void showQRGenerated(String eventId, String studentId, String eventName,
      String studentName, BuildContext context) {
    final media = MediaQuery.of(context);
    _isLoading = true;
    var qrImage = QrImage(
      data: "DDUAttendanceSystem;" +
          eventId +
          ";" +
          studentId +
          ";" +
          eventName +
          ";" +
          studentName,
    );
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        scrollable: true,
        title: Text("QR Code"),
        content: Center(
          child: Container(
            width: 0.6 * media.size.width,
            height: 0.3 *
                (media.size.height - media.padding.top - media.padding.bottom),
            child: qrImage,
          ),
        ),
        actions: [
          new FlatButton(
              minWidth: 100,
              color: Colors.blue,
              child: Text("Done"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User usr = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // backgroundColor: Colors.white70,
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
            var studentName = snapshot.data["name"];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
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
                        var e = eventdata.data;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    height:
                                        (MediaQuery.of(context).size.height -
                                                MediaQuery.of(context)
                                                    .padding
                                                    .top) *
                                            0.082,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ExpansionTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Text(
                                          e["name"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                        e['date'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.qr_code),
                                            color: Colors.white,
                                            onPressed: () {
                                              showQRGenerated(
                                                  e.documentID,
                                                  usr.uid,
                                                  e["name"],
                                                  studentName,
                                                  context);
                                            },
                                          ),
                                        ],
                                      ),
                                      key: ValueKey(e.documentID),
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white30,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              e['description'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
            );
          }),
    );
  }
}
