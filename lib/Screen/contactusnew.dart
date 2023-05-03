import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Helper/Color.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        title: Text("Contact Us"),),
      body: Container(child: Text("pet&poultrycare@gmail.com"),),
    );
  }
}
