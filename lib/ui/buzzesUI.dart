import 'package:flutter/material.dart';
import 'buzzListsUI/allBuzzList.dart';
import 'buzzListsUI/eventBuzzList.dart';
import 'buzzListsUI/infoBuzzLIst.dart';
import 'buzzListsUI/pollBuzzList.dart';

class Buzzes extends StatefulWidget {
  final int channelIndex;
  Buzzes({this.channelIndex});
  @override
  State<StatefulWidget> createState() {
    return BuzzesState(channelIndex: channelIndex);
  }
}

class BuzzesState extends State<Buzzes> with AutomaticKeepAliveClientMixin {
  final int channelIndex;
  BuzzesState({this.channelIndex});

  @override
  bool get wantKeepAlive => true;

  final List<Widget> tabs = [
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('ALL')),
    Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('INFO')),
    Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('EVENTS')),
    Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10), child: Text('POLLS')),
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
          child: Column(children: <Widget>[
            TabBar(
              unselectedLabelColor: Theme.of(context).accentColor,
              labelColor: Color.fromRGBO(249, 249, 255, 1),
              indicator: BoxDecoration(
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //       blurRadius: 3.0,
                  //       color: Colors.blue,
                  //       offset: Offset.fromDirection(3),
                  //       spreadRadius: 2)
                  // ],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16)),
                  color: Theme.of(context).accentColor),
              tabs: tabs,
              isScrollable: true,
            ),
            Divider(
              height: 0,
            ),
            Expanded(
              child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    // AllBuzz(),
                    InfoBuzz(),
                    EventBuzz(),
                    PollBuzz(),
                  ]),
            )
          ]),
        ));
  }
}
