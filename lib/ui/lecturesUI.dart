import 'package:flutter/material.dart';
import 'lectureDay.dart';
import '../core/constants.dart' show Days;

class Lectures extends StatelessWidget {
  final int channelIndex;
  Lectures({this.channelIndex});

  final List<Widget> tabs = [
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('MON')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('TUE')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('THU')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('WED')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('FRI')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('SAT')),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: tabs,
              isScrollable: true,
            ),
            Divider(
              height: 0,
            ),
            // indicator: BoxDecoration(color: Theme.of(context).accentColor)),
            Expanded(
                child: PageView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                LectureDay(
                  day: Days.monday, 
                  channelIndex: channelIndex
                  ),
                LectureDay(
                  day: Days.tuesday,
                  channelIndex: channelIndex,
                ),
                LectureDay(
                  day: Days.wednesday,
                  channelIndex: channelIndex,
                ),
                LectureDay(
                  day: Days.thursday,
                  channelIndex: channelIndex,
                ),
                LectureDay(
                  day: Days.friday,
                  channelIndex: channelIndex,
                ),
                LectureDay(
                  day: Days.saturday,
                  channelIndex: channelIndex,
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
