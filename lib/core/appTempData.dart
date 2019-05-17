import 'channel.dart';
import 'course.dart';
import 'lecture.dart';

class AppTempData {
  ///Example of Channel
  static List<Channel> channels = [
    Channel(
        channelTitle: "Computer Science CLASS",
        channelId: "CS_021",
        channelBase: "University of Ibadan",
        myCurrentBuzzes: 1,
        channelMembers: 123),
    Channel(
        channelTitle: "Economics CLASS",
        channelId: "EC_021",
        channelBase: "University of Nigeria",
        myCurrentBuzzes: 0,
        channelMembers: 143),
    Channel(
        channelTitle: "Fine Arts Channel",
        channelId: "FA_023",
        channelBase: "University of Uyo",
        myCurrentBuzzes: 7,
        channelMembers: 0),
  ];

  void addDefaut() {
    channels[0].courses.add(Course(
        channelId: 'SOMETHJI',
        courseCode: 'SGLJG',
        courseTitle: 'SomeTiltl',
        lecturerName: 'Mr DLKJ',
        lecturerOffice: 'Some Office',
        unitLoad: 6));

    channels[0].allLectureDays.mondayLectures.add(Lecture(
        course: channels[0].courses[0],
        dayOfWeek: 0,
        location: 'FPSLT',
        startTime: '19:00',
        endTime: '21:00'));
  }
}
