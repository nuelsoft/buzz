import 'package:flutter/material.dart';
import 'lectureItem.dart';
import '../../core/lecture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/ui/emptySpace.dart';
import '../../core/course.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:buzz/ui/inChannel.dart';
import 'package:buzz/ui/notificationMan.dart';

class LectureList extends StatefulWidget {
  final int dayOfWeek;
  final String channelID;
  final BuzzNotification bz;
  final Firestore fstore = Firestore.instance;
  bool registeredLectures = false;
  LectureList({this.dayOfWeek, this.channelID, this.bz});
  @override
  State<StatefulWidget> createState() {
    if (!registeredLectures) {
      registerallNotification();
    }
    return LectureListState(dayOfWeek: dayOfWeek, channelID: channelID);
  }

  Future<void> registerallNotification() async {
    await fstore.collection('channels').document(channelID).get().then((val) {
      List dummy = val.data['lecturesOrder'][dayOfWeek.toString()];

      for (int i = 0; i < dummy.length; i++) {
        // print(dummy);
        // print(val.data['lectures'][dayOfWeek.toString()]);
        // print(dummy[i]['key']);
        var secdummy =
            val.data['lectures'][dayOfWeek.toString()][dummy[i]['key']];
        print(secdummy.toString());
        if (secdummy != null) {
          if (secdummy['course'] != null) {
            int hour;
            Day day;
            TimeOfDay(
                hour: secdummy['startTimeHour'],
                minute: secdummy['startTimeMinute']);
            hour = (secdummy['startTimeHour'] == 0)
                ? 23
                : secdummy['startTimeHour'] - 1;

            switch (dayOfWeek) {
              case 0:
                day = Day.Monday;
                break;
              case 1:
                day = Day.Tuesday;
                break;
              case 2:
                day = Day.Wednesday;
                break;
              case 3:
                day = Day.Thursday;
                break;
              case 4:
                day = Day.Friday;
                break;
              case 5:
                day = Day.Saturday;
            }

            bz.addNotification(
                secdummy['course']['courseCode'],
                Time(
                  hour,
                  secdummy['startTimeMinute'],
                  0,
                ),
                day,
                dayOfWeek);
            registeredLectures = true;
          }
        }
      }
    });
  }
}

class LectureListState extends State<LectureList>
    with AutomaticKeepAliveClientMixin {
  int dayOfWeek;
  String channelID;
  bool registeredLectures = false;

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
            } else if (snapshot.data['lecturesOrder'][dayOfWeek.toString()] ==
                null) {
              return Center(
                child: Text('No Lectures today'),
              );
            } else if (snapshot
                    .data['lecturesOrder'][dayOfWeek.toString()].length ==
                0) {
              return Center(
                child: Text('No Lectures today'),
              );
            } else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount:
                    snapshot.data['lecturesOrder'][dayOfWeek.toString()].length,
                itemBuilder: (context, index) {
                  var snp = snapshot.data['lectures'][dayOfWeek.toString()][
                      snapshot.data['lecturesOrder'][dayOfWeek.toString()]
                          [index]['key']];
                  if (snp != null) {}
                  return (snp != null)
                      ? (snp['course'] != null)
                          ? LectureItemUI(
                              // index: index,
                              ds: snapshot.data['lecturesOrder']
                                  [dayOfWeek.toString()][index]['key'],
                              lecturesOrder: snapshot.data['lecturesOrder']
                                  [dayOfWeek.toString()][index],
                              dayOfWeek: dayOfWeek.toString(),
                              channelID: channelID,
                              lecture: Lecture(
                                  course: Course(
                                      courseCode: snp['course']['courseCode'],
                                      unitLoad:
                                          int.tryParse(snp['course']['units']),
                                      recommendedText: '',
                                      lecturerOffice: '',
                                      courseTitle: snp['course']['courseTitle'],
                                      lecturerName: ''),
                                  dayOfWeek: snp['dayOfWeek'],
                                  endTime: snp['endTimeHour'].toString() +
                                      ':' +
                                      ((snp['endTimeMinute'] == 0)
                                          ? '00'
                                          : snp['endTimeMinute'].toString()),
                                  isFixed: snp['isFixed'],
                                  location: snp['location'],
                                  startTime: snp['startTimeHour'].toString() +
                                      ':' +
                                      ((snp['startTimeMinute'] == 0)
                                          ? '00'
                                          : snp['startTimeMinute'].toString())),
                            )
                          : EmptySpace()
                      : EmptySpace();
                },
              );
            }
        }
      },
    );
  }
}
