import 'dart:ffi';
import 'dart:math';
import 'dart:developer';
import 'package:business/main.dart';
import 'package:business/screens/add_products.dart';
import 'package:business/screens/edit_product.dart';
import 'package:business/screens/login_registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart.dart';

final _auth = FirebaseAuth.instance;
dynamic loggedInUser;
double total = 0;
var CartItem = new Map();

class Products extends StatefulWidget {
  //late Map allvalues;
  late List allvalues;
  late DatabaseReference _reference;
  late String useremail = "";
  Products(this.allvalues, this.useremail, this._reference);
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Products> {
  double _rate = 0.0;
  late TextEditingController _qtyController;
  //double total = 0;
  double rate = 0;
  //bool _isloading = true;
  final FirebaseAuth auth = FirebaseAuth.instance;

  late TextEditingController _nameController;
  //late Map CartItem = {};

  late Map contact;
  late List<dynamic> keys;

  late List<dynamic> user;
  late List<dynamic> filteredUsers;

  late DatabaseReference reference = widget._reference;
  late String _useremail = widget.useremail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getchanges();
    user = widget.allvalues;

    filteredUsers = user;
    _nameController = TextEditingController();
    _qtyController = TextEditingController();
  }

  void getchanges() {
    reference.orderByChild('name').onValue.listen((event) async {
      var snapshot = await event.snapshot;
      // print("dathanged");
      //late Map allvalues;
      setState(() {
        if (snapshot.value != null) {
          contact = snapshot.value;
          contact.forEach((k, v) {
            v['key'] = k;
            v['rate'] = 0.0;
          });

          user = contact.values.toList();
          filteredUsers = user;
        } else {
          //print("HI");
          user = [];
          filteredUsers = [];
        }
        //print(user);
        // CartItem['-1'] = contact['-1'];
      });
    });
  }

  Widget _buildContactItem(Map contacts) {
    // Color typeColor = getTypeColor(contact['type']);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medication,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Flexible(
                child: Text(
                  contacts['name'] + ' (₹${contacts['mrp']})',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cost = ₹" + contacts['cp'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                  child: Text(
                "Sell Rate = ₹" + contacts['sp'],
                maxLines: 2,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              )),
              SizedBox(width: 15),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Scheme = ₹" + contacts['type'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  "In-Stock = ${contacts['qty']}",
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 15),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: TextField(
                    onChanged: (e) {
                      setState(() {
                        try {
                          contacts['temp_qty_pur'] = e;

                          String r =
                              (double.parse(e) * double.parse(contacts['sp']))
                                  .toStringAsFixed(2);
                          contacts['temp_rate'] = double.parse(r);
                        } on Exception catch (exception) {
                          contacts['temp_rate'] = 0;
                          // only executed if error is of type Exception
                        }
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'QTY',
                      isDense: true, // Added this
                    ),
                    style: TextStyle(height: 1.0, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Text(
                "₹${contacts['temp_rate']}",
                style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 50,
              ),
              TextButton(
                child: Text("ADD", style: TextStyle(fontSize: 14)),
                style: ButtonStyle(
                  // padding:
                  //     MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                onPressed: () {
                  //total += contacts['rate'];
                  contacts['rate'] = contacts['temp_rate'];
                  contacts['qty_pur'] = contacts['temp_qty_pur'];
                  CartItem[contacts['key']] = contacts;
                  //print("$CartItem");
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  print(contacts['key']);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              EditProduct(contacts['key'], _useremail)));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Edit',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  _showDeleteDialog(contacts);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Delete',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showDeleteDialog(Map contacts) {
    showDialog(
        context: context,
        builder: (context) {
          print(contacts);
          return AlertDialog(
            title: Text('Delete ${contacts['name']}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    _nameController.text = '';
                    reference.child(contacts['key']).remove().whenComplete(() {
                      getchanges();
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  _searchBar() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: _nameController,
          decoration: InputDecoration(hintText: 'Search your product... '),
          onChanged: (string) {
            setState(() {
              filteredUsers = user
                  .where((u) => (u['name']
                      .toLowerCase()
                      .startsWith(string.toLowerCase())))
                  .toList();
            });
          }),
    ));
  }

  _noitemfound() {
    return Column(
      children: [
        Center(
          child: Image(
            image: AssetImage('images/bag.jfif'),
            height: 100.0,
          ),
        ),
        Text('No data found')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('My Products'),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email');
                  await FirebaseAuth.instance.signOut();

                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RegistrationScreen()));
                  // do something
                },
              ),
              IconButton(
                onPressed: () {
                  //print(CartItem);
                  total = 0;
                  CartItem.forEach((key, value) {
                    total += value['rate'];
                  });
                  List cartList = CartItem.values.toList();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Cart(total, CartItem, _useremail)));
                },
                icon: Icon(
                  Icons.shopping_cart_rounded,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                _searchBar(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return AddProducts(_useremail);
                        },
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add_box,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),
              ],
            ),
            Expanded(
              child: filteredUsers.length == 0
                  ? _noitemfound()
                  : ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: filteredUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print(filteredKeys[index]);
                        return _buildContactItem(filteredUsers[index]);
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
