import 'package:flutter/material.dart';
import 'lecturesUI.dart';
import 'coursesUI.dart';
import 'buzzesUI.dart';

class MainPageView extends StatelessWidget {

  int channelIndex;

  MainPageView({@required channelIndex});

  final int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[Lectures(channelIndex: channelIndex), Courses(), Buzzes()],
    );
  }
}
