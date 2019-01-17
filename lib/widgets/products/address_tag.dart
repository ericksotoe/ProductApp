import 'package:flutter/material.dart';

class AdressTag extends StatelessWidget {
  final String address;

  AdressTag(this.address);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 1.0),
          borderRadius: BorderRadius.circular(4.0)),
      child: Text(address),
    );
  }
}
