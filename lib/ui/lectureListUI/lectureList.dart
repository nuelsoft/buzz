import 'package:flutter/material.dart';
import 'lectureItem.dart';
import '../../core/lecture.dart';

import '../../core/course.dart';

class LectureList extends StatefulWidget {
  final List<Lecture> lectures;

  LectureList({this.lectures});

  @override
  State<StatefulWidget> createState() {
    return LectureListState(lectures: lectures);
  }
}

class LectureListState extends State<LectureList>
    with AutomaticKeepAliveClientMixin {
  List<Lecture> lectures;

  LectureListState({@required lectures});

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: lectures.length,
      itemBuilder: (context, index) {
        return LectureItemUI(lecture: lectures[index]);
      },
    );
  }
}
