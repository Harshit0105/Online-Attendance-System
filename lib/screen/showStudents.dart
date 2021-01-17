import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShowStudentScreen extends StatefulWidget {
  static const routeName = "./showStudentScreen";
  ShowStudentScreen({Key key}) : super(key: key);

  @override
  _ShowStudentScreenState createState() => _ShowStudentScreenState();
}

class _ShowStudentScreenState extends State<ShowStudentScreen> {
  String semester = '';
  String dept;
  QuerySnapshot querySnapshot;
  bool isLoading;

  @override
  void initState() {
    semester = "1";
    isLoading = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    dept = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  void changeSemester(String value) {
    setState(() {
      semester = value;
    });
  }

  void showItemUpdateDialog(
    String docId,
    String name,
    String id,
    String pass,
    BuildContext context,
  ) {
    String sName = name.toUpperCase();

    var dialog = new AlertDialog(
      title: new Text("Are you sure!!"),
      content: new RichText(
        text: new TextSpan(
          style: new TextStyle(
            fontSize: 14.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            new TextSpan(text: 'Do you wanr to delete student '),
            new TextSpan(
                text: '$sName',
                style: new TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: Text("cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
            color: Colors.red,
            child: Text("Delete"),
            onPressed: () {
              deleteStudent(docId, id, pass, context);
              Navigator.of(context).pop();
            }),
      ],
    );

    showDialog(context: context, child: dialog);
  }

  static Future<bool> delete(
      String email, String password, BuildContext context) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .signInWithEmailAndPassword(email: email, password: password);
      print("usr done");
      final User user = FirebaseAuth.instanceFor(app: app).currentUser;
      user.delete().then((value) => print("Deleted!!")).catchError((onError) {
        app.delete();
        return Future.sync(() => false);
      });
      await app.delete();
      return Future.sync(() => true);
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
    } catch (error) {
      print(error);
    }
  }

  void deleteStudent(
      String docId, String id, String pass, BuildContext context) async {
    String email = "$id@ddu.com";
    setState(() {
      isLoading = true;
    });
    var poss = await delete(email, pass, context);
    if (poss) {
      await FirebaseFirestore.instance
          .collection("students")
          // ignore: deprecated_member_use
          .document(docId)
          .delete()
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("users")
            // ignore: deprecated_member_use
            .document(docId)
            .delete()
            .then((value) {
          print("Delete collection");
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    //bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student List",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15.0,
            ),
            child: Text("Semester:",
                style: TextStyle(
                  fontSize: 18,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButton(
              hint: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "$semester",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              items: [
                DropdownMenuItem(
                  child: Text("Sem 1"),
                  value: "1",
                ),
                DropdownMenuItem(
                  child: Text("Sem 2"),
                  value: "2",
                ),
                DropdownMenuItem(
                  child: Text("Sem 3"),
                  value: "3",
                ),
                DropdownMenuItem(
                  child: Text("Sem 4"),
                  value: "4",
                ),
                DropdownMenuItem(
                  child: Text("Sem 5"),
                  value: "5",
                ),
                DropdownMenuItem(
                  child: Text("Sem 6"),
                  value: "6",
                ),
                DropdownMenuItem(
                  child: Text("Sem 7"),
                  value: "7",
                ),
                DropdownMenuItem(
                  child: Text("Sem 8"),
                  value: "8",
                ),
              ],
              onChanged: (value) {
                changeSemester(value);
              },
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('students')
            .where("dept", isEqualTo: dept)
            .where("sem", isEqualTo: semester)
            .orderBy("name", descending: false)
            .snapshots(),
        builder: (ctx, chatSnapShot) {
          if (chatSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDoc = chatSnapShot.data.documents;
          if (chatDoc.length == 0) {
            return Center(
              child: Text(
                "No student found",
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
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: chatDoc.length,
                    itemBuilder: (ctx, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            chatDoc[index]['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          subtitle: Text(
                            chatDoc[index]['id'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              showItemUpdateDialog(
                                  chatDoc[index].documentID,
                                  chatDoc[index]['name'],
                                  chatDoc[index]['id'],
                                  chatDoc[index]['dob'],
                                  context);
                            },
                          ),
                          key: ValueKey(chatDoc[index].documentID),
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
