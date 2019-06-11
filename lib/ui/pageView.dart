import 'package:flutter/material.dart';
import 'lecturesUI.dart';
import 'coursesUI.dart';
import 'buzzesUI.dart';
import '../core/genFiles.dart';

class MainPageView extends StatefulWidget {
  final int channelIndex;
  final PageController pgc;

  MainPageView({this.channelIndex, this.pgc});

  @override
  State<StatefulWidget> createState() {
    return MainPageViewState(channelIndex: channelIndex, pgc: pgc);
  }
}

class MainPageViewState extends State<MainPageView> {
  final int channelIndex;
  final PageController pgc;

  MainPageViewState({this.channelIndex, this.pgc});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pgc,
      onPageChanged: (index) {
        setState(() {
                  GenFiles.selectedIndex = index;
                  
                });
      },
      physics: BouncingScrollPhysics(),
      // physics:
      children: <Widget>[
        Lectures(channelIndex: channelIndex),
        Courses(
          channelIndex: channelIndex,
        ),
        Buzzes(channelIndex: channelIndex)
      ],
    );
  }
}
