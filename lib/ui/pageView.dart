import 'package:flutter/material.dart';
import 'lecturesUI.dart';
import 'coursesUI.dart';
import 'buzzesUI.dart';
import '../core/genFiles.dart';
import 'package:buzz/ui/notificationMan.dart';

class MainPageView extends StatefulWidget {
  final String channelID;
  final PageController pgc;
  final BuzzNotification bz;

  MainPageView({this.channelID, this.pgc, this.bz});

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
      physics: NeverScrollableScrollPhysics(),
      // physics:
      children: <Widget>[
        Lectures(channelID: channelID, bz: widget.bz),
        Courses(
          channelID: channelID,
        ),
        Buzzes(channelID: channelID)
      ],
    );
  }
}
