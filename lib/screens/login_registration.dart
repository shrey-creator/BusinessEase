import 'package:business/screens/loading_screen.dart';
import 'package:business/screens/products.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/round_buttions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  //static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // bool isloggedin = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _insuccess = false;
  bool _upsuccess = false;
  late TextEditingController _emailController, _passController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final _auth = FirebaseAuth.instance;
  late String _useremail;
  late String password;

  _showDeleteDialog(String alertText) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('AlertDialog'),
        content: Text('$alertText'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passController.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', '${_emailController.text}');
      setState(() {
        _upsuccess = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) {
          return LoadingScreen();
        }),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _upsuccess = false;
      });
      if (e.code == 'weak-password') {
        _showDeleteDialog("The password provided is too weak.");
        //print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showDeleteDialog("The account already exists for that email.");
        // print('The account already exists for that email.');
      }
    } catch (e) {
      setState(() {
        _upsuccess = false;
      });
      print(e);
    }
  }

  void _signin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passController.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', '${_emailController.text}');
      // print("signed in");
      setState(() {
        _insuccess = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) {
          return LoadingScreen();
        }),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _insuccess = false;
      });
      if (e.code == 'user-not-found') {
        _showDeleteDialog("No user found for that email.");
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showDeleteDialog("Wrong password provided for that user.");
        // print('Wrong password provided for that user.');
      }
    }
  }

  //bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Image(
                  image: AssetImage('images/bag.jfif'),
                  height: 100.0,
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password length should be more than 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: _insuccess
                    ? CircularProgressIndicator()
                    : TextButton(
                        child: Text("Sign In".toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(15)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                        onPressed: () {
                          _useremail = _emailController.text;
                          password = _passController.text;
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _insuccess = true;
                            });
                            print(_useremail);
                            print(password);
                            _signin();
                          }
                        },
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: _upsuccess
                    ? CircularProgressIndicator()
                    : TextButton(
                        child: Text("Register".toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(15)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                        onPressed: () {
                          _useremail = _emailController.text;
                          password = _passController.text;
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _upsuccess = false;
                            });
                            print(_useremail);
                            print(password);
                            _register();
                          }
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
