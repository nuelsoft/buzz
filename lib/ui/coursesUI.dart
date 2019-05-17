import 'package:flutter/material.dart';

class Courses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(physics: BouncingScrollPhysics(), children: <Widget>[
              Container(color: Colors.indigo),
              Container(color: Colors.red),
              Container(color: Colors.blue),
              Container(color: Colors.white),
              Container(color: Colors.yellow),
              Container(color: Colors.black),
            ]);
  }
}
