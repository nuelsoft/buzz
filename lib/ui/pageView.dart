import 'package:flutter/material.dart';
import 'lecturesUI.dart';
import 'coursesUI.dart';
import 'buzzesUI.dart';
import '../core/genFiles.dart';

class MainPageView extends StatefulWidget {
  final String channelID;
  final PageController pgc;

  MainPageView({this.channelID, this.pgc});

  @override
  State<StatefulWidget> createState() {
    return MainPageViewState(channelID: channelID, pgc: pgc);
  }
}

class MainPageViewState extends State<MainPageView> {
  final String channelID;
  final PageController pgc;

  MainPageViewState({this.channelID, this.pgc});

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
        Lectures(channelID: channelID),
        Courses(
          channelID: channelID,
        ),
        Buzzes(channelID: channelID)
      ],
    );
  }
}
