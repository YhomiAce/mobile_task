// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;
  var isLoading = false;

  handleFieldChange(String val, String type) {
    if (type == 'email') {
      setState(() {
        _email = val;
      });
    } else if (type == 'username') {
      setState(() {
        _username = val;
      });
    } else if (type == 'password') {
      setState(() {
        _password = val;
      });
    }
  }

  validateForm() async {
    setState(() {
      isLoading = true;
    });
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formKey.currentState!.save();

      submitHandler(_email, _password, _username);
    }
  }

  showMessage(String message, String type) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: type == 'error'
            ? Colors.red
            : type == 'warning'
                ? Colors.yellow
                : type == 'success'
                    ? Colors.green
                    : Colors.blueAccent,
        duration: Duration(seconds: 5),
      ),
    );
  }

  submitHandler(String email, String password, String username) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential authResult;
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
        });
      }
      setState(() {
        isLoading = false;
      });
      print(authResult);
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showMessage('No user found for that email.', 'error');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showMessage('Wrong password provided for that user.', 'error');
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        showMessage('The password provided is too weak.', 'warning');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        showMessage('The account already exists for that email.', 'warning');
      }
    } catch (err) {
      log('Err');
      log(err.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log(_email);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage) UsernameField(_username, handleFieldChange),
                  EmailField(_email, handleFieldChange),
                  PasswordField(_password, handleFieldChange),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: validateForm,
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              isLoginPage ? 'Login' : 'Signup ',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextButton(
                      child: Text(isLoginPage
                          ? 'Not a member, Signup'
                          : 'Already has an account, login'),
                      onPressed: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget PasswordField(String password, Function handleFieldChange) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Password",
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      TextFormField(
        keyboardType: TextInputType.visiblePassword,
        key: ValueKey('password'),
        obscureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Invalid Password';
          } else if (value.length < 5) {
            return 'Password is too short';
          }
          return null;
        },
        onSaved: (newValue) {
          password = newValue!;
          handleFieldChange(newValue, 'password');
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(),
          ),
          labelText: 'Enter Password',
          labelStyle: GoogleFonts.roboto(),
        ),
      ),
      SizedBox(
        height: 8,
      ),
    ],
  );
}

Widget EmailField(String email, Function handleFieldChange) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email",
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        key: ValueKey('email'),
        validator: (value) {
          if (value!.isEmpty || !value.contains('@')) {
            return 'Invalid Email';
          }
          return null;
        },
        onSaved: (newValue) {
          log(newValue!);
          email = newValue;
          handleFieldChange(newValue, 'email');
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(),
          ),
          labelText: 'Enter Email',
          labelStyle: GoogleFonts.roboto(),
        ),
      ),
      SizedBox(
        height: 8,
      ),
    ],
  );
}

Widget UsernameField(String username, Function handleFieldChange) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username",
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        key: ValueKey('username'),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Invalid Username';
          }
          return null;
        },
        onSaved: (newValue) {
          username = newValue!;
          handleFieldChange(newValue, 'username');
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(),
          ),
          labelText: 'Enter Username',
          labelStyle: GoogleFonts.roboto(),
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}
