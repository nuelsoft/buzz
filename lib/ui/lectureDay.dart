import 'package:flutter/material.dart';
import '../core/appManager.dart';
import '../core/lecture.dart';

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

  List<Step> steps = [];
  void prepareTodayList() {
    List<Lecture> todaysList;
    if (AppManager.channels != null) {
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
      for (var cls in todaysList) {
        steps.add(Step(
            title: Text(cls.course.courseTitle),
            content: StepperContent(
              code: cls.course.courseCode,
              location: cls.location,
              unitLoad: cls.course.unitLoad,
            )));
      }
    }
  }

  Widget parseLectures() {
    prepareTodayList();
    if (steps.length > 0) {
      return Container(
        child: Stepper(
          steps: steps,
          physics: BouncingScrollPhysics(),
        ),
      );
    } else {
      return Container(child: Center(child: Text('No Lectures Today!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return parseLectures();
  }
}

class StepperContent extends StatelessWidget {
  final String code;
  final String location;
  final int unitLoad;
  // final String endTime;
  // final String startTime;

  StepperContent({this.code, this.location, this.unitLoad});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(children: [
          Text(code,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w500)),
          Row(
            children: <Widget>[Icon(Icons.location_on), Text(location)],
          )
        ]),
      ),
    );
  }
}
