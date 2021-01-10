import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;
  final void Function(
    String email,
    String password,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userPassword = '';
  FocusNode _passwordFocus;
  FocusNode _emailFocus;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email Address",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0.2,
                                  color: Colors.white,
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
                                _userEmail = value;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 0.2,
                                  color: Colors.white,
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
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () => node.unfocus(),
                              focusNode: _passwordFocus,
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value.isEmpty || value.length != 10) {
                                  return 'Please provide valid password!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              onSaved: (value) {
                                _userPassword = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1,
                          color: Color(0xff9bc5c3),
                          spreadRadius: 5,
                        )
                      ],
                      color: Color(0xff9bc5c3),
                      borderRadius: new BorderRadius.circular(15),
                    ),
                    child: widget.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : FlatButton(
                            onPressed: _trySubmit,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 25,
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
