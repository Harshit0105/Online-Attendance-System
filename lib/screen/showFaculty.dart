import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShowFacultyScreen extends StatefulWidget {
  static const routeName = "./showFacultyScreen";
  ShowFacultyScreen({Key key}) : super(key: key);

  @override
  _ShowFacultyScreenState createState() => _ShowFacultyScreenState();
}

class _ShowFacultyScreenState extends State<ShowFacultyScreen> {
  String dept;
  bool isLoading;
  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    dept = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  void showItemUpdateDialog(
    String docId,
    String name,
    String email,
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
            new TextSpan(text: 'Do you wanr to delete faculty '),
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
              deleteFaculty(docId, email, pass, context);
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

  void deleteFaculty(
      String docId, String email, String pass, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    var poss = await delete(email, pass, context);
    if (poss) {
      await FirebaseFirestore.instance
          .collection("faculites")
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Faculty List",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('faculties')
            .where("dept", isEqualTo: dept)
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
                "No Faculty found",
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
                            chatDoc[index]['email'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              showItemUpdateDialog(
                                  chatDoc[index].documentID,
                                  chatDoc[index]['name'],
                                  chatDoc[index]['email'],
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
