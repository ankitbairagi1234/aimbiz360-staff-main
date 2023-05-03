import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TNC extends StatefulWidget {
  const TNC({Key? key}) : super(key: key);

  @override
  State<TNC> createState() => _TNCState();
}

class _TNCState extends State<TNC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        title: Text("Terms & Condition"),),
      body: Container(child: Center(child: Text("No Data Found")),),
    );
  }
}
