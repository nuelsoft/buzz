import 'package:flutter/material.dart';
import '../core/constants.dart' show Days;
import 'tickerProv.dart' show VState;
import 'package:buzz/ui/lectureListUI/lectureList.dart';
import 'package:buzz/core/genFiles.dart';
import 'package:buzz/ui/notificationMan.dart';

class Lectures extends StatefulWidget {
  final String channelID;
  final BuzzNotification bz;
  Lectures({this.channelID, this.bz});

  @override
  State<StatefulWidget> createState() {
    return LecturesState(channelID: channelID);
  }
}

class LecturesState extends State<Lectures> with AutomaticKeepAliveClientMixin {
  String channelID;
  LecturesState({this.channelID});

  static final List<Widget> tabs = [
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('MON')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('TUE')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('WED')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('THU')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('FRI')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('SAT')),
  ];

  @override
  bool get wantKeepAlive => true;

  PageController pgControl = PageController(initialPage: GenFiles.innerSelectedIndex, keepPage: true);
  TabController tbControl =
      TabController(length: tabs.length, vsync: VState(), initialIndex: GenFiles.innerSelectedIndex);
  _pageChanged(index) {
    setState(() {
      GenFiles.innerSelectedIndex = index;
      tbControl.animateTo(index,
          curve: Curves.easeInSine, duration: Duration(milliseconds: 200));
    });
  }

  _tapped(index) {
    GenFiles.innerSelectedIndex = index;
    pgControl.animateToPage(index,
        curve: Curves.easeInSine, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
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
                LectureList(dayOfWeek: Days.monday, channelID: channelID, bz: widget.bz),
                LectureList(
                  dayOfWeek: Days.tuesday,
                  channelID: channelID, bz: widget.bz
                ),
                LectureList(
                  dayOfWeek: Days.wednesday,
                  channelID: channelID, bz: widget.bz
                ),
                LectureList(
                  dayOfWeek: Days.thursday,
                  channelID: channelID, bz: widget.bz
                ),
                LectureList(
                  dayOfWeek: Days.friday,
                  channelID: channelID, bz: widget.bz
                ),
                LectureList(
                  dayOfWeek: Days.saturday,
                  channelID: channelID, bz: widget.bz
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
