import 'package:flutter/material.dart';

class StudentRegistrationForm extends StatefulWidget {
  StudentRegistrationForm({Key key, this.submitFn, this.isLoading, this.dept})
      : super(key: key);
  final bool isLoading;
  final String dept;
  final void Function(
    String name,
    String id,
    String birthDate,
    String gender,
    String department,
    String sem,
    String batch,
    BuildContext ctx,
  ) submitFn;
  @override
  _StudentRegistrationFormState createState() =>
      _StudentRegistrationFormState();
}

class _StudentRegistrationFormState extends State<StudentRegistrationForm> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _id = "";
  String _birthDate = "";
  String _gender = "";
  String _department = "";
  String _sem = "";
  String _batch = "";
  FocusNode _nameFocus;
  FocusNode _idFocus;

  DateTime _selectedDate;
  String genderRadio;
  List<String> _batches;
  List<String> _semesters = ["1", '2', '3', '4', '5', '6', '7', '8'];
  void radioButtonChanges(String value) {
    setState(() {
      genderRadio = value;
      switch (value) {
        case 'Male':
          _gender = value;
          break;
        case 'Female':
          _gender = value;
          break;
        case 'Other':
          _gender = value;
          break;
        default:
          _gender = "Male";
      }
      debugPrint(_gender); //Debug the choice in console
    });
  }

  @override
  void initState() {
    setState(() {
      genderRadio = "Male";
      _gender = "Male";
      _sem = "1";
      switch (widget.dept) {
        case "CE":
          _batches = ["C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"];
          break;
        case "MH":
          // TODO: change batches for MH
          _batches = ["C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"];
          break;
        case "IT":
          // TODO: change batches for IT
          _batches = ["C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"];
          break;
        case "CH":
          // TODO: change batches for CH
          _batches = ["C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"];
          break;
        default:
          _batches = ["C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"];
          break;
      }
      _batch = _batches[0];
    });
    super.initState();
  }

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
      _department = widget.dept;
      _birthDate =
          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
      _formKey.currentState.reset();
      setState(() {
        _selectedDate = null;
      });
      widget.submitFn(
        _name.trim(),
        _id.trim(),
        _birthDate.trim(),
        _gender.trim(),
        _department.trim().toUpperCase(),
        _sem.trim(),
        _batch.trim().toUpperCase(),
        context,
      );
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
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
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
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
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              focusNode: _nameFocus,
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
                  //Student ID
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Student ID",
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
                              onEditingComplete: () => node.nextFocus(),
                              focusNode: _idFocus,
                              key: ValueKey('id'),
                              validator: (value) {
                                if (value.isEmpty || value.length != 10) {
                                  return 'Please enter a valid ID';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusColor: Colors.black,
                              ),
                              onSaved: (value) {
                                _id = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Birth Date
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Birth Date",
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
                                      : 'Picked Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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
                  //Gender
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gender",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio(
                              value: "Male",
                              groupValue: genderRadio,
                              onChanged: radioButtonChanges,
                            ),
                            Text(
                              "Male",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Radio(
                              value: "Female",
                              groupValue: genderRadio,
                              onChanged: radioButtonChanges,
                            ),
                            Text(
                              "Female",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Radio(
                              value: "Other",
                              groupValue: genderRadio,
                              onChanged: radioButtonChanges,
                            ),
                            Text(
                              "Other",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //Semester
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
                  //Batch
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.cyan,
                    ),
                    width: 150,
                    height: 60,
                    child: FlatButton(
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
