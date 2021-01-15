import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyRegistrationForm extends StatefulWidget {
  FacultyRegistrationForm({Key key, this.submitFn, this.isLoading, this.dept})
      : super(key: key);
  final bool isLoading;
  final String dept;
  final void Function(
    String name,
    String email,
    String password,
    String birthDate,
    String mobile,
    String gender,
    String department,
    BuildContext ctx,
  ) submitFn;

  @override
  _FacultyRegistrationFormState createState() =>
      _FacultyRegistrationFormState();
}

class _FacultyRegistrationFormState extends State<FacultyRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  String _name = "";
  String _email = "";
  String _mobile = "";
  String _birthDate = "";
  String _gender = "";
  String _department = "";
  String _password = "";
  FocusNode _nameFocus;
  FocusNode _emailFocus;
  FocusNode _mobileFocus;
  FocusNode _passwordFocus;
  DateTime _selectedDate;
  String genderRadio;

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
      _birthDate = "${formatter.format(_selectedDate)}";
      _formKey.currentState.reset();
      setState(() {
        _selectedDate = null;
      });
      widget.submitFn(
        _name.trim(),
        _email.trim(),
        _password.trim(),
        _birthDate.trim(),
        _mobile.trim(),
        _gender.trim(),
        _department.trim().toUpperCase(),
        context,
      );
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
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
                          "Email ID",
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
                              focusNode: _emailFocus,
                              key: ValueKey('email'),
                              validator: (value) {
                                if (value.isEmpty ||
                                    !value.contains('@') ||
                                    !value.contains('.com')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusColor: Colors.black,
                              ),
                              onSaved: (value) {
                                _email = value;
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
                  //Password
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
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
                              focusNode: _passwordFocus,
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 10) {
                                  return 'Please enter a valid number(At least 10 characters)';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusColor: Colors.black,
                              ),
                              onSaved: (value) {
                                _password = value;
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
                  //Mobile Number
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mobile No.",
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
                              onEditingComplete: () => node.unfocus(),
                              focusNode: _mobileFocus,
                              key: ValueKey('mobile'),
                              validator: (value) {
                                if (value.isEmpty || value.length != 10) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusColor: Colors.black,
                              ),
                              onSaved: (value) {
                                _mobile = value;
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
