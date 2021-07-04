import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class AddProducts extends StatefulWidget {
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddProducts> {
  late TextEditingController _nameController,
      _numberController,
      _spController,
      _mrpController,
      _quantityController;
  //late String _typeSelected = '';

  late DatabaseReference _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _spController = TextEditingController();
    _mrpController = TextEditingController();
    _quantityController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('Products');

    //_ref = FirebaseDatabase.instance.reference().child('Products');
  }
  //
  // Widget _buildContactType(String title) {
  //   return InkWell(
  //     child: Container(
  //       height: 40,
  //       width: 90,
  //       decoration: BoxDecoration(
  //         color: _typeSelected == title
  //             ? Colors.green
  //             : Theme.of(context).accentColor,
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       child: Center(
  //         child: Text(
  //           title,
  //           style: TextStyle(fontSize: 18, color: Colors.white),
  //         ),
  //       ),
  //     ),
  //     onTap: () {
  //       setState(() {
  //         _typeSelected = title;
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Save Contact'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter Medicine Name',
                prefixIcon: Icon(
                  Icons.medication,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _mrpController,
              decoration: InputDecoration(
                hintText: 'Enter M.R.P',
                prefixIcon: Icon(
                  Icons.money,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _numberController,
              decoration: InputDecoration(
                hintText: 'Enter C.P.',
                prefixIcon: Icon(
                  Icons.money,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _spController,
              decoration: InputDecoration(
                hintText: 'Enter S.P.',
                prefixIcon: Icon(
                  Icons.money,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(
                hintText: 'Enter Quantity ',
                prefixIcon: Icon(
                  Icons.production_quantity_limits,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                child: Text(
                  'Save Contact',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  saveContact();
                },
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveContact() {
    String name = _nameController.text;
    String number = _numberController.text;
    String sp = _spController.text;
    String mrp = _mrpController.text;
    String quantity = _quantityController.text;
    Map<String, String> contact = {
      'name': name,
      'cp': 'C.P. = ₹' + number,
      'sp': 'S.P. = ₹' + sp,
      'mrp': mrp,
      'type': quantity,
    };

    _ref.push().set(contact).then((value) {
      Navigator.pop(context);
    });
  }
}
