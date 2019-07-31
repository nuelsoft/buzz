import 'package:flutter/material.dart';
import 'lectureItem.dart';
import '../../core/lecture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/course.dart';

class LectureList extends StatefulWidget {
  final int dayOfWeek;
  final String channelID;

  LectureList({this.dayOfWeek, this.channelID});
  @override
  State<StatefulWidget> createState() {
    return LectureListState(dayOfWeek: dayOfWeek, channelID: channelID);
  }
}

class LectureListState extends State<LectureList>
    with AutomaticKeepAliveClientMixin {
  int dayOfWeek;
  String channelID;

  Firestore fstore = Firestore.instance;
  LectureListState({this.dayOfWeek, this.channelID});

  @override
  bool get wantKeepAlive => true;

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
            if (snapshot.data['lectures'] == null) {
              return (Center(
                child: Text('No lecture Data found'),
              ));
            } else if (snapshot.data['lectures'][dayOfWeek.toString()] ==
                null) {
              return Center(
                child: Text('No Lectures today'),
              );
            } else if (snapshot.data['lectures'][dayOfWeek.toString()].length ==
                0) {
              return Center(
                child: Text('No Lectures today'),
              );
            } else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount:
                    snapshot.data['lectures'][dayOfWeek.toString()].length,
                itemBuilder: (context, index) {
                  var snp = snapshot.data['lectures'][dayOfWeek.toString()];
                  return LectureItemUI(
                    lecture: Lecture(
                        course: Course(
                            courseCode: snp[index]['course']['courseCode'],
                            unitLoad:
                                int.tryParse(snp[index]['course']['units']),
                            recommendedText: '',
                            lecturerOffice: '',
                            courseTitle: snp[index]['course']['courseTitle'],
                            lecturerName: ''),
                        dayOfWeek: snp[index]['dayOfWeek'],
                        endTime: snp[index]['endTimeHour'].toString() +
                            ':' +
                            ((snp[index]['endTimeMinute'] == 0)
                                ? '00'
                                : snp[index]['endTimeMinute'].toString()),
                        isFixed: snp[index]['isFixed'],
                        location: snp[index]['location'],
                        startTime: snp[index]['startTimeHour'].toString() +
                            ':' +
                            ((snp[index]['startTimeMinute'] == 0)
                                ? '00'
                                : snp[index]['startTimeMinute'].toString())),
                  );
                },
              );
            }
        }
      },
    );
  }
}
