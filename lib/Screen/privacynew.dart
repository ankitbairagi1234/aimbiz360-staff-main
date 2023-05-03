import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Helper/Color.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        title: Text("Privacy Policy"),),
      body: Container(child: Center(child: Text("No Data Found")),),
    );
  }
}
