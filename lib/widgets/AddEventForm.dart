import 'package:E_Attendance/widgets/FacultyRegistrationForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddEventForm extends StatefulWidget {
  AddEventForm({Key key, this.submitFn, this.isLoading, this.dept})
      : super(key: key);
  final bool isLoading;
  final String dept;
  final void Function(
    String name,
    String desc,
    String date,
    String sem,
    String batch,
    BuildContext ctx,
  ) submitFn;
  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  String _sem = "";
  String _batch = "";
  String _name = "";
  String _eventDate = "";
  String _description = "";
  List<String> _batches;
  List<String> _semesters = ["1", '2', '3', '4', '5', '6', '7', '8'];

  DateTime _selectedDate;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      if (_selectedDate == null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Please provide all data"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      _eventDate = "${formatter.format(_selectedDate)}";
      _formKey.currentState.reset();
      setState(() {
        _selectedDate = null;
      });
      widget.submitFn(
        _name.trim(),
        _description.trim(),
        _eventDate.trim(),
        _sem.trim(),
        _batch.trim(),
        context,
      );
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  void initState() {
    setState(() {
      _sem = "1";
      switch (widget.dept) {
        case "CE":
          _batches = ["C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"];
          break;
        case "EC":
          _batches = ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4"];
          break;
        case "MH":
          _batches = ["J1", "J2", "J3", "J4", "K1", "K2", "K3", "K4"];
          break;
        case "IT":
          _batches = ["H1", "H2", "H3", "H4", "I1", "I2", "I3", "I4"];
          break;
        case "CH":
          _batches = ["F1", "F2", "F3", "F4", "L1", "L2", "L3", "L4"];
          break;
        default:
          _batches = ["C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"];
          break;
      }
      _batches.insert(0, "ALL");
      _batch = _batches[0];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Name
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0.2,
                                  color: Colors.black12,
                                  spreadRadius: 3)
                            ],
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 2,
                            ),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.done,
                              key: ValueKey('name'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a valid Name';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusColor: Colors.black,
                              ),
                              onSaved: (value) {
                                _name = value;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Description
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0.2,
                                  color: Colors.black12,
                                  spreadRadius: 3)
                            ],
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 2,
                            ),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              textInputAction: TextInputAction.done,
                              key: ValueKey('desc'),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusColor: Colors.black,
                              ),
                              onSaved: (value) {
                                _description = value;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Event Date
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Event Date",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0.2,
                                  color: Colors.black12,
                                  spreadRadius: 3)
                            ],
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.black,
                                  ),
                                  onPressed: _presentDatePicker,
                                ),
                                Text(
                                  _selectedDate == null
                                      ? 'Not choosen!'
                                      : 'Picked Date: ${formatter.format(_selectedDate)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Semester And Batch
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Semester",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 0.2,
                                      color: Colors.black12,
                                      spreadRadius: 3)
                                ],
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 2,
                                  bottom: 2,
                                ),
                                child: Container(
                                  width: 150,
                                  child: DropdownButton(
                                    // hint: Text('Please choose a Semester'),
                                    value: _sem,
                                    onChanged: (value) {
                                      setState(() {
                                        _sem = value;
                                      });
                                    },
                                    items: _semesters.map((location) {
                                      return DropdownMenuItem(
                                        child: new Text(location),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 0,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Batch",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 0.2,
                                      color: Colors.black12,
                                      spreadRadius: 3)
                                ],
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 0,
                                  bottom: 2,
                                ),
                                child: Container(
                                  width: 150,
                                  child: DropdownButton(
                                    // hint: Text('Please choose a Batch'),
                                    value: _batch,
                                    onChanged: (value) {
                                      setState(() {
                                        _batch = value;
                                      });
                                    },
                                    items: _batches.map((location) {
                                      return DropdownMenuItem(
                                        child: new Text(location),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  //Add Button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.cyan,
                    ),
                    width: 150,
                    height: 60,
                    child: widget.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : FlatButton(
                            onPressed: _trySubmit,
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
