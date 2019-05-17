import 'course.dart';

class Lecture {
  Course course;
  String startTime, endTime, location;
  int dayOfWeek;

  Lecture({
    this.course,
    this.startTime,
    this.endTime,
    this.location,
    this.dayOfWeek,
  });
}
