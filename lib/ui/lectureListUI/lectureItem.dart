import 'package:flutter/material.dart';
import 'isFixed.dart';
import '../../core/lecture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';

class LectureItemUI extends StatelessWidget {
  final Lecture lecture;
  final String channelID;
  final String dayOfWeek;
  final String ds;
  final lecturesOrder;
  final Firestore fstore = Firestore.instance;
  LectureItemUI(
      {this.lecture,
      this.channelID,
      this.dayOfWeek,
      this.ds,
      this.lecturesOrder});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            RaisedButton(
              onPressed: () {},
              color: Color.fromRGBO(235, 235, 255, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                  child: Text("${lecture.startTime} - ${lecture.endTime}")),
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
                      width: 3, color: Color.fromRGBO(223, 223, 223, 1)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: FlatButton(
                  // elevation: 3,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 100,
                            child: Padding(
                                padding: EdgeInsets.all(0),
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  children: <Widget>[
                                    ListTile(
                                        title: Text('Remove Lecture'),
                                        onTap: () {
                                          // fstore
                                          //     .collection('channels')
                                          //     .document(channelID)
                                          //     .setData({
                                          //   'lecturesOrder': {
                                          //     dayOfWeek: {
                                          //       FieldValue.arrayRemove(
                                          //           [lecturesOrder])
                                          //     }
                                          //   }
                                          // }, merge: true);

                                          fstore
                                              .collection('channels')
                                              .document(channelID)
                                              .setData({
                                            'lectures': {
                                              dayOfWeek: {ds: null}
                                            }
                                          }, merge: true);
                                          Navigator.pop(context);
                                          // fstore
                                          //     .collection('channels')
                                          //     .document(channelID)
                                          //     .setData({
                                          //   'lectures': {
                                          //     dayOfWeek: {
                                          //       FieldValue.arrayRemove([ds])
                                          //     }
                                          //   }
                                          // }, merge: true);
                                        })
                                  ],
                                )),
                          );
                        });
                  },
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
                                Container(
                                  width: 100,
                                    child: Text(
                                  '${lecture.location}',
                                  overflow: TextOverflow.ellipsis,
                                ))
                              ],
                            ),
                            Text(
                                '${lecture.course.unitLoad} ${(lecture.course.unitLoad > 1) ? 'units' : 'unit'}')
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
