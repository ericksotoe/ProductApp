import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';

import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
//  _showWarningDialog(BuildContext context) {
//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: Text("Are you Sure?"),
//            content: Text("This action cannot be undone!"),
//            actions: <Widget>[
//              FlatButton(
//                child: Text("NO, CANCEL"),
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//              ),
//              FlatButton(
//                child: Text("YES, CONTINUE"),
//                onPressed: () {
//                  Navigator.pop(context); // closes the dialog
//                  Navigator.pop(context,
//                      true); // navigates away with true val saying yes i want to delte this
//                },
//              ),
//            ],
//          );
//        });
//  }

  final Product product;

  ProductPage(this.product);

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Union Square, San Francisco",
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              "|",
              style: TextStyle(color: Colors.grey),
            )),
        Text('\$' + price.toString(),
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("Back Button Pressed");
        Navigator.pop(context, false);
        return Future.value(false); // allows to leave
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FadeInImage(
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/food.jpg'),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TitleDefault(product.title),
            ),
            _buildAddressPriceRow(product.price),
            Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ))

//            Container(
//              padding: EdgeInsets.all(10.0),
//              child: RaisedButton(
//                color: Theme.of(context).accentColor,
//                child: Text("Delete", style: TextStyle(color: Colors.white),),
//                onPressed: () => _showWarningDialog(context),
//              ),
//            )
          ],
        ),
      ),
    );
  }
}
