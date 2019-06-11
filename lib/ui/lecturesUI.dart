import 'package:flutter/material.dart';
import 'lectureDay.dart';
import '../core/constants.dart' show Days;
import 'tickerProv.dart' show VState;

class Lectures extends StatefulWidget {
  final int channelIndex;
  Lectures({this.channelIndex});

  @override
  State<StatefulWidget> createState() {
    return LecturesState(channelIndex: channelIndex);
  }
}

class LecturesState extends State<Lectures> with AutomaticKeepAliveClientMixin {
  int channelIndex;
  LecturesState({this.channelIndex});

  static final List<Widget> tabs = [
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('MON')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('TUE')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('THU')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('WED')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('FRI')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('SAT')),
  ];

  @override
  bool get wantKeepAlive => true;

  PageController pgControl = PageController(initialPage: 0, keepPage: true);
  TabController tbControl =
      TabController(length: tabs.length, vsync: VState(), initialIndex: 0);
  _pageChanged(index) {
    setState(() {
      tbControl.animateTo(index,
          curve: Curves.easeInSine, duration: Duration(milliseconds: 200));
    });
  }

  _tapped(index) {
    pgControl.animateToPage(index,
        curve: Curves.easeInSine, duration: Duration(milliseconds: 200));
  }

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
              onTap: _tapped,
              controller: tbControl,
            ),
            Divider(
              height: 0,
            ),
            // indicator: BoxDecoration(color: Theme.of(context).accentColor)),
            Expanded(
                child: PageView(
              controller: pgControl,
              onPageChanged: _pageChanged,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                LectureDay(day: Days.monday, channelIndex: channelIndex),
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
