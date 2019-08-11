import 'package:flutter/material.dart';
import '../../core/course.dart';
import '../emptySpace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseItem extends StatelessWidget {
  final Course course;
  final bool isLast;
  final DocumentSnapshot ds;
  final Firestore fstore = Firestore.instance;
  CourseItem({this.course, this.isLast, this.ds});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
              context: context,
              builder: (_) => Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15))),
                    height: 170,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                              top: 16,
                              left: 16,
                            ),
                            child: Text(
                              '${course.courseCode}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )),
                        ListTile(
                          title: Text('Remove Course'),
                          onTap: () {
                            fstore
                                .collection('channels')
                                .document(course.channelId)
                                .setData({
                              'coursesOrder':
                                  FieldValue.arrayRemove([course.courseCode])
                            }, merge: true);
                            fstore
                                .collection('channels')
                                .document(course.channelId)
                                .setData({
                              'courses': {'courseCode': null}
                            }, merge: true);

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ));
        },
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15))),
                height: 150,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Recommended Texts',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, right: 12, left: 12),
                      child: Text((course.recommendedText == null)
                          ? 'No recommended Texts'
                          : course.recommendedText),
                    )
                  ],
                )),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 2),
          child: Column(children: <Widget>[
            Text(course.courseTitle,
                style: TextStyle(fontSize: 17),
                overflow: TextOverflow.ellipsis),
            Padding(
              padding: EdgeInsets.only(
                top: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    course.courseCode,
                  ),
                  Row(children: <Widget>[
                    Text(
                      'lecturer: ',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text(
                      (course.lecturerName == null)
                          ? 'Not Identified'
                          : course.lecturerName,
                      overflow: TextOverflow.ellipsis,
                    )
                  ])
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'office: ',
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Text(
                        (course.lecturerOffice == null)
                            ? 'No Idea'
                            : course.lecturerOffice,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    '${course.unitLoad.toString()} ${(course.unitLoad > 1) ? 'units' : 'unit'}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      (!isLast) ? Divider() : EmptySpace()
    ]);
  }
}
