import 'package:flutter/material.dart';
import '../core/appTempData.dart';

class CourseList extends StatelessWidget {
  final int channelIndex;
  CourseList({this.channelIndex});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {},
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return _courseEntry(index: index, channelIndex: channelIndex);
        },
      ),
    );
  }

  Widget _courseEntry({int index, int channelIndex}) {
    return Container(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(4),
          child: Text('Introducion to Computer Science'),
        )
      ],
    ));
  }
}
