import 'package:flutter/material.dart';
import './core/AppTempData.dart';

class CourseList extends StatelessWidget {
  final int channelIndex;
  CourseList({this.channelIndex});
  
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {},
      child: ListView.builder(
        itemCount: AppTempData.channels[channelIndex].courses.length,
        itemBuilder: (context, index) {
          return _courseEntry(index: index, channelIndex: channelIndex);
        },
      ),
    );
  }

  Widget _courseEntry({int index, int channelIndex}) {
    return Card(
        child: Text(
            AppTempData.channels[channelIndex].courses[index].courseTitle));
  }
}
