import 'dart:math';
import 'dart:developer';
import 'package:business/main.dart';
import 'package:business/screens/add_products.dart';
import 'package:business/screens/edit_product.dart';
import 'package:business/screens/login_registration.dart';
import 'package:business/screens/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final _auth = FirebaseAuth.instance;
dynamic loggedInUser;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  late TextEditingController _nameController;
  late Query _ref;
  late DatabaseReference reference;
  late String _useremail = "";
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      loggedInUser = user;
      if (user != null) {
        _useremail = loggedInUser.email.replaceAll(".", "");

        print(_useremail);
        getdata(_useremail);
      }
    } catch (e) {
      print(e);
    }
  }

  void getSnapshot(List user) async {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Products(user, _useremail, reference);
    }));
  }

  void getdata(String mail) async {
    reference = FirebaseDatabase.instance
        .reference()
        .child('${mail}')
        .child('Products');
    //console.log(_ref);
    _ref = reference.orderByChild('name');
    late Map allvalues;
    //
    List user = [];
    await _ref.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        allvalues = snapshot.value;
        allvalues.forEach((k, v) {
          v['key'] = k;
          v['temp_rate'] = 0.0;
          v['rate'] = 0.0;
        });
        user = allvalues.values.toList();
      }
    });

    //print(allvalues);
    getSnapshot(user);
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    // print("end init");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
