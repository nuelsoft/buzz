import 'package:flutter/material.dart';
import 'lecturesUI.dart';
import 'coursesUI.dart';
import 'buzzesUI.dart';

class MainPageView extends StatelessWidget {
  final int channelIndex;

  MainPageView({this.channelIndex});

  final int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        // Lectures(
        //   channelIndex: channelIndex
        //   ),
        // Courses(
        //   channelIndex: channelIndex,
        // ),
        Buzzes(channelIndex: channelIndex)
      ],
    );
  }
}
