import 'package:flutter/material.dart';
import 'courseListUI/courseList.dart';

class Courses extends StatefulWidget {
  final String channelID;
  Courses({this.channelID});

  @override
    State<StatefulWidget> createState() {
      return CoursesState(channelID: channelID);
    }
}

class CoursesState extends State<Courses>  with AutomaticKeepAliveClientMixin{
  final String channelID;
  CoursesState({this.channelID});

  @override
    bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: CourseList(
          channelID: channelID,
        ));
  }
}
