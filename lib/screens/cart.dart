import 'package:business/screens/products.dart';
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'dart:math';
import 'dart:developer';
import 'package:business/main.dart';
import 'package:business/screens/products.dart';
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

class Cart extends StatefulWidget {
  Map CartItem = <dynamic, dynamic>{};
  double total;
  String email;
  Cart(this.total, this.CartItem, this.email);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Map cartShow = <dynamic, dynamic>{};
  late DatabaseReference _ref;
  double _total = 0.0;
  late List cartList;
  //Cart_show=widget.CartItem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartShow = widget.CartItem;
    // print(cartShow);
    cartList = cartShow.values.toList();
    _total = widget.total;
    // print("${total} cart ");
    String result = (widget.email).replaceAll(".", "");
    _ref = FirebaseDatabase.instance
        .reference()
        .child('$result')
        .child('Products');
  }

  Widget _buildContactItem(int index, Map contacts) {
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
                  '${contacts['name']} ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "QTY :  ",
                style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.black,
                    fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 50.0),
                  child: TextFormField(
                    initialValue: contacts['qty_pur'],
                    onChanged: (e) {
                      setState(() {
                        try {
                          contacts['qty_pur'] = e;
                          _total -= contacts['rate'];
                          String r =
                              (double.parse(e) * double.parse(contacts['sp']))
                                  .toStringAsFixed(2);
                          contacts['rate'] = double.parse(r);

                          _total += contacts['rate'];
                        } on Exception catch (exception) {
                          contacts['rate'] = 0;
                          // only executed if error is of type Exception
                        }
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'QTY',
                      isDense: true, // Added this
                    ),
                    style: TextStyle(height: 0.5, color: Colors.black),
                  ),
                ),
              ),
              Text(
                "Rate per product : ${contacts['sp']}",
                style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.black,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Total Rate : ${contacts['rate']}",
            style: TextStyle(
                fontSize: 16,
                color: CupertinoColors.black,
                fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    cartList.removeAt(index);
                    cartShow.remove(contacts['key']);
                    _total -= contacts['rate'];
                    total -= contacts['rate'];
                    print(total);
                  });
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
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Cart'),
              Text("TOTAL : ₹ ${_total.toStringAsFixed(2)}"),
            ]),
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: cartShow.length == 0
                  ? _noitemfound()
                  : ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: cartList.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print(filteredKeys[index]);
                        return Container(
                          child: _buildContactItem(index, cartList[index]),
                        );
                      }),
            ),
            TextButton(
              child: Text("Sell Cart", style: TextStyle(fontSize: 14)),
              style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 30.0)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              onPressed: () {
                cartShow.forEach((k, v) {
                  v['qty'] = v['qty'] - int.parse(v['qty_pur']);
                  Map<String, dynamic> contact = {
                    'name': v['name'],
                    'cp': v['cp'],
                    'sp': v['sp'],
                    'mrp': v['mrp'],
                    'type': v['type'],
                    'qty': v['qty'],
                    'rate': 0.0
                  };
                  print(contact);
                  _ref.child(k).update(contact).then((value) {
                    setState(() {
                      cartList.remove(v);
                    });

                    cartShow.remove(k);
                  });
                  // print(contact);
                });
                setState(() {
                  _total = 0.0;
                });
                total = 0;
              },
            ),
            TextButton(
              child: Text("Clear Cart", style: TextStyle(fontSize: 14)),
              style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 30.0)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  cartList.clear();
                  cartShow.clear();
                  _total = 0.0;
                });
                total = 0;
              },
            ),
          ],
        ),
      ),
    );
  }
}
