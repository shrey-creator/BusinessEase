import 'package:business/screens/loading_screen.dart';
import 'package:business/screens/login_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:splashscreen/splashscreen.dart';
import 'screens/products.dart';
import 'package:firebase_core/firebase_core.dart';

final _auth = FirebaseAuth.instance;
dynamic loggedInUser;
var email;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  //print(email);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: email == null ? MyApp() : Home()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Database',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.redAccent,
      ),
      home: RegistrationScreen(),
    );
  }
}

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Products',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.redAccent,
      ),
      home: LoadingScreen(),
    );
  }
}
