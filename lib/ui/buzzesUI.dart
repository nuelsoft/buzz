import 'package:flutter/material.dart';
import 'buzzListsUI/allBuzzList.dart';
import 'buzzListsUI/eventBuzzList.dart';
import 'buzzListsUI/infoBuzzLIst.dart';
import 'buzzListsUI/pollBuzzList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/core/appManager.dart';
// import 'package:buzz/core/constants.dart';
import 'package:buzz/ui/tickerProv.dart';

class Buzzes extends StatefulWidget {
  final String channelID;
  Buzzes({this.channelID});
  final Firestore fstore = Firestore.instance;
  @override
  State<StatefulWidget> createState() {
    fstore.collection('channels').document(channelID).get().then((val) {
      fstore.collection('userData').document(AppManager.myUserID).setData({
        'channelLog': {
          channelID: {'currentNotifications': val.data['currentNotifications']}
        }
      }, merge: true);
    });
    return BuzzesState(channelID: channelID);
  }
}

class BuzzesState extends State<Buzzes> with AutomaticKeepAliveClientMixin {
  final String channelID;
  BuzzesState({this.channelID});

  @override
  bool get wantKeepAlive => true;

  static final List<Widget> tabs = [
    Padding(padding: EdgeInsets.only(top: 8, bottom: 8), child: Text('ALL')),
    Padding(padding: EdgeInsets.only(top: 8, bottom: 8), child: Text('INFO')),
    Padding(padding: EdgeInsets.only(top: 8, bottom: 8), child: Text('EVENTS')),
    Padding(padding: EdgeInsets.only(top: 8, bottom: 8), child: Text('POLLS')),
  ];

  PageController pgControl = PageController(initialPage: 0, keepPage: true);
  TabController tbControl =
      TabController(length: tabs.length, vsync: VState(), initialIndex: 0);

  _tapped(index) {
    pgControl.animateToPage(index,
        curve: Curves.easeInSine, duration: Duration(milliseconds: 200));
  }

  _pageChanged(index) {
    setState(() {
      tbControl.animateTo(index,
          curve: Curves.easeInSine, duration: Duration(milliseconds: 200));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: DefaultTabController(
          length: tabs.length,
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(4),
              child: TabBar(
                controller: tbControl,
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
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Theme.of(context).accentColor),
                tabs: tabs,
                isScrollable: true,
                onTap: _tapped,
              ),
            ),
            Divider(
              height: 0,
            ),
            Expanded(
              child: PageView(
                  controller: pgControl,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: _pageChanged,
                  children: <Widget>[
                    AllBuzz(channelID: channelID),
                    // (AppManager.channels.length >= channelIndex + 1 &&
                    InfoBuzz(
                      channelID: channelID,
                    ),
                    EventBuzz(
                      channelID: channelID,
                    ),
                    // (AppManager.channels.length >= channelIndex + 1 &&
                    PollBuzz(
                      channelID: channelID,
                    )
                  ]),
            )
          ]),
        ));
  }
}
