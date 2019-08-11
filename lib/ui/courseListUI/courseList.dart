import 'package:flutter/material.dart';
import '../../core/course.dart';
import 'courseItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CourseList extends StatefulWidget {
  final String channelID;
  CourseList({this.channelID});

  @override
  State<StatefulWidget> createState() {
    return CourseListState(channelID: channelID);
  }
}

class CourseListState extends State<CourseList> {
  List<Course> courses;
  final String channelID;

  final Firestore fstore = Firestore.instance;

  CourseListState({this.channelID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fstore.collection('channels').document(channelID).snapshots(),
      builder: (builder, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
       
            return (snapshot.hasData && snapshot.data['coursesOrder'] != null)
                ? (snapshot.data['coursesOrder'].length != null ||
                        snapshot.data['coursesOrder'].length != 0)
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data['coursesOrder'].length,
                        itemBuilder: (context, index) {
                          return CourseItem(
                            isLast: ((index + 1) ==
                                    snapshot.data['coursesOrder'].length)
                                ? true
                                : false,
                            course: Course(
                                channelId: channelID,
                                courseCode: snapshot.data['courses']
                                        [snapshot.data['coursesOrder'][index]]
                                    ['courseCode'],
                                courseTitle: snapshot.data['courses']
                                        [snapshot.data['coursesOrder'][index]]
                                    ['courseTitle'],
                                lecturerName: snapshot.data['courses']
                                        [snapshot.data['coursesOrder'][index]]
                                    ['lecturerName'],
                                lecturerOffice: snapshot.data['courses']
                                        [snapshot.data['coursesOrder'][index]]
                                    ['lecturerOffice'],
                                unitLoad:
                                    int.tryParse(snapshot.data['courses'][snapshot.data['coursesOrder'][index]]['units'].toString()),
                                recommendedText: snapshot.data['courses'][snapshot.data['coursesOrder'][index]]['recommendText']),
                          );
                        },
                      )
                    : Center(
                        child: Text('No Courses!'),
                      )
                : Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('No Courses Registered'),
                        )
                      ]));
        }
      },
    );
  }
}
