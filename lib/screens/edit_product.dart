import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class EditProduct extends StatefulWidget {
  String contactKey, email;

  EditProduct(this.contactKey, this.email);
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
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
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _spController = TextEditingController();
    _mrpController = TextEditingController();
    _quantityController = TextEditingController();
    _qtyController = TextEditingController();
    String result = (widget.email).replaceAll(".", "");
    print(result);
    _ref = FirebaseDatabase.instance
        .reference()
        .child('$result')
        .child('Products');
    getContactDetail();
    //_ref = FirebaseDatabase.instance.reference().child('Products');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Edit Product'),
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
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _numberController,
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
            TextFormField(
              controller: _spController,
              decoration: InputDecoration(
                hintText: 'Sell Rate',
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
              controller: _quantityController,
              decoration: InputDecoration(
                hintText: 'Scheme',
                prefixIcon: Icon(
                  Icons.confirmation_number,
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                child: Text(
                  'Save Changes',
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

  getContactDetail() async {
    DataSnapshot snapshot = await _ref.child(widget.contactKey).once();

    Map contact = snapshot.value;

    _nameController.text = contact['name'];
    _numberController.text = contact['cp'];
    _spController.text = contact['sp'];
    _mrpController.text = contact['mrp'];
    _quantityController.text = contact['type'];
    _qtyController.text = contact['qty'].toString();
  }

  void saveContact() {
    String name = _nameController.text;
    String number = _numberController.text;
    String sp = _spController.text;
    String mrp = _mrpController.text;
    String quantity = _quantityController.text;
    int qty = int.parse(_qtyController.text);

    Map<String, dynamic> contact = {
      'name': name,
      'cp': number,
      'sp': sp,
      'mrp': mrp,
      'type': quantity,
      'qty': qty,
      'rate': 0.0
    };

    _ref.child(widget.contactKey).update(contact).then((value) {
      Navigator.pop(context);
    });
  }
}
