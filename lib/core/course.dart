import 'recommendedText.dart';

class Course {
  String courseTitle;
  String courseCode;
  String lecturerName;
  String lecturerOffice;
  int unitLoad;
  String channelId;
  List<RecommendedText> recommendedText;
   Course(
      {this.courseTitle,
      this.courseCode,
      this.lecturerName,
      this.lecturerOffice,
      this.unitLoad,
      this.channelId,
      this.recommendedText});
}