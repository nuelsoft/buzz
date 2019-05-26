import 'package:flutter/material.dart';
import 'isFixed.dart';
import '../../core/lecture.dart';

class LectureItemUI extends StatelessWidget {
  final Lecture lecture;
  LectureItemUI({this.lecture});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            FlatButton(
              onPressed: () {},
              color: Color.fromRGBO(235, 235, 255, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                  child: Text(
                      "${lecture.startTime} - ${lecture.endTime}")),
            ),
            Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '${lecture.course.courseCode}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ))
          ]),
          Padding(
            padding: EdgeInsets.only(left: 35),
            child: Container(
              // color: Colors.red,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      width: 3, color: Color.fromRGBO(203, 204, 204, 1)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: RaisedButton(
                  elevation: 3,
                  onPressed: () {},
                  color: Color.fromRGBO(244, 244, 244, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        IsFixed(isFixed: lecture.isFixed)
                      ]),
                      Text(
                        '${lecture.course.courseTitle}',
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                ),
                                Text(
                                  '${lecture.location}',
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                            Text('${lecture.course.unitLoad} ${(lecture.course.unitLoad > 1) ? 'units' : 'unit'}')
                          ]),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
