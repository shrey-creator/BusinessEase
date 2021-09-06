import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class AddProducts extends StatefulWidget {
  String _email;

  AddProducts(this._email);
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddProducts> {
  bool _isloading = false;
  late TextEditingController _nameController,
      _numberController,
      _spController,
      _mrpController,
      _quantityController,
      _qtyController;

  //late String _typeSelected = '';

  late DatabaseReference _ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String result = (widget._email).replaceAll(".", "");
    //print(result);
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _spController = TextEditingController();
    _mrpController = TextEditingController();
    _quantityController = TextEditingController();
    _qtyController = TextEditingController();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('${result}')
        .child('Products');

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
                hintText: 'Enter Product Name',
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
                hintText: 'M.R.P.',
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
                hintText: 'Cost Rate',
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
                hintText: 'Purchase Rate',
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
                hintText: 'Scheme ',
                prefixIcon: Icon(
                  Icons.confirmation_number,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            TextFormField(
              controller: _qtyController,
              decoration: InputDecoration(
                hintText: 'Enter stock ',
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
              child: _isloading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text(
                        'Save Product',
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

  Future<bool> printFirebase(String name) async {
    int check = 0;
    await _ref.once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        return false;
      }
      Map<dynamic, dynamic> values = snapshot.value;

      // print(values.toString());
      //print(name);

      values.forEach((k, v) {
        //print(v['name']);
        if (v["name"].toString() == name) {
          //print("exist");
          check = 1;
        }
      });
    });
    if (check == 1) {
      return true;
    }
    return false;
  }

  void saveContact() async {
    setState(() {
      _isloading = true;
    });
    String name = _nameController.text;
    name = name.toLowerCase();
    String number = _numberController.text == '' ? '0' : _numberController.text;
    String sp = _spController.text == '' ? '0' : _spController.text;
    String mrp = _mrpController.text;
    String quantity = _quantityController.text;
    int qty = int.parse(_qtyController.text);
    bool nameExist = await printFirebase(name);
    // print(nameExist);
    //nameExist = true;
    // bool nameExist = false;
    setState(() {
      _isloading = false;
    });

    if (nameExist) {
      _showDeleteDialog("Product is already in the list!! ");
    } else {
      Map<String, dynamic> contact = {
        'name': name,
        'cp': number,
        'sp': sp,
        'mrp': mrp,
        'type': quantity,
        'qty': qty,
        'rate': 0.0
      };

      _ref.push().set(contact).then((value) {
        Navigator.pop(context);
      });
    }
  }
}
