import 'package:flutter/material.dart';
import '../core/appManager.dart';
import '../core/lecture.dart';
import 'lectureListUI/lectureList.dart';

class LectureDay extends StatefulWidget {
  final int day;
  final int channelIndex;

  LectureDay({this.day, this.channelIndex});

  @override
  State<StatefulWidget> createState() {
    return LectureDayState(day: day, channelIndex: channelIndex);
  }
}

class LectureDayState extends State<LectureDay> {
  int day;
  int channelIndex;
  LectureDayState({this.day, this.channelIndex});

  List<Lecture> todaysList;
  void prepareTodayList() {
    if (AppManager.channels != null && AppManager.channels.length > 0) {
      switch (day) {
        case 0:
          todaysList =
              AppManager.channels[channelIndex].allLectureDays.mondayLectures;
          break;
        case 1:
          todaysList =
              AppManager.channels[channelIndex].allLectureDays.tuesdayLectures;
          break;
        case 2:
          todaysList = AppManager
              .channels[channelIndex].allLectureDays.wednesdayLectures;
          break;
        case 3:
          todaysList =
              AppManager.channels[channelIndex].allLectureDays.thursdayLectures;
          break;
        case 4:
          todaysList =
              AppManager.channels[channelIndex].allLectureDays.fridayLectures;
          break;
        case 5:
          todaysList =
              AppManager.channels[channelIndex].allLectureDays.saturdayLectues;
          break;
      }
    }
  }

  Widget parseLectures() {
    prepareTodayList();
    if (todaysList != null && todaysList.length > 0) {
      return LectureList(lectures: todaysList);
    } else {
      return Container(child: Center(child: Text('No Lectures Today!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return parseLectures();
  }
}