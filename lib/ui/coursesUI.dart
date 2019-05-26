import 'package:flutter/material.dart';
import 'courseListUI/courseList.dart';

class Courses extends StatelessWidget {
  final int channelIndex;
  Courses({this.channelIndex});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: CourseList(
          channelIndex: channelIndex,
        ));
  }
}
