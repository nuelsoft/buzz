import 'package:flutter/material.dart';
import '../../core/course.dart';
import 'courseItem.dart';
import '../../core/appManager.dart';

class CourseList extends StatefulWidget {
  final int channelIndex;

  CourseList({this.channelIndex});

  @override
  State<StatefulWidget> createState() {
    return CourseListState(channelIndex: channelIndex);
  }
}

class CourseListState extends State<CourseList> {
  List<Course> courses;
  final int channelIndex;

  CourseListState({this.channelIndex});

  void prepareCourses() {
    if (AppManager.channels != null && AppManager.channels.length > 0) {
      // courses = AppManager.channels[channelIndex].courses;
      //demo
      courses = [
        Course(
            channelId: 'THA',
            courseCode: 'COS201',
            courseTitle: 'Programming',
            unitLoad: 4,
            lecturerName: 'Odogwu',
            recommendedText: null,
            lecturerOffice: 'FPSLT'),
        Course(
            channelId: 'THA',
            courseCode: 'COS201',
            courseTitle: 'Programming',
            unitLoad: 4,
            lecturerName: 'Odogwu',
            recommendedText: null,
            lecturerOffice: 'FPSLT'),
        Course(
            channelId: 'THA',
            courseCode: 'COS201',
            courseTitle: 'Programming',
            unitLoad: 4,
            lecturerName: 'Odogwu',
            recommendedText: null,
            lecturerOffice: 'FPSLT'),
        Course(
            channelId: 'THA',
            courseCode: 'COS201',
            courseTitle: 'Programming',
            unitLoad: 4,
            lecturerName: 'Odogwu',
            recommendedText: null,
            lecturerOffice: 'FPSLT'),
        Course(
            channelId: 'THA',
            courseCode: 'COS201',
            courseTitle: 'Programming',
            unitLoad: 4,
            lecturerName: 'Odogwu',
            recommendedText: null,
            lecturerOffice: 'FPSLT'),
   
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (courses != null && courses.length > 0) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          CourseItem(course: courses[index]);
        },
      );
    } else {
      return Center(child: Text('No course added yet'));
    }
  }
}
