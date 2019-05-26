import 'package:flutter/material.dart';
import '../../core/course.dart';
import '../emptySpace.dart';
import 'recommendedList.dart';

class CourseItem extends StatelessWidget {
  final Course course;
  final bool isLast;
  CourseItem({this.course, this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FlatButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => BottomSheet(
              builder: (_) => RecommendedTextList(texts: course.recommendedText,),
              enableDrag: true,
              onClosing: (){
              }, 
            )
          );
        },
        child: Padding(
          padding: EdgeInsets.only(top: 8, left: 2, right: 2, bottom: 2),
          child: Column(children: <Widget>[
            Text(course.courseTitle,
                style: TextStyle(fontSize: 17),
                overflow: TextOverflow.ellipsis),
            Padding(
              padding: EdgeInsets.only(top: 8),
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
                      course.lecturerName,
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
                        course.lecturerOffice,
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
