import 'package:flutter/material.dart';
import 'courseListUI/courseList.dart';

class Courses extends StatefulWidget {
  final int channelIndex;
  Courses({this.channelIndex});

  @override
    State<StatefulWidget> createState() {
      return CoursesState(channelIndex: channelIndex);
    }
}

class CoursesState extends State<Courses>  with AutomaticKeepAliveClientMixin{
  final int channelIndex;
  CoursesState({this.channelIndex});

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
          channelIndex: channelIndex,
        ));
  }
}
