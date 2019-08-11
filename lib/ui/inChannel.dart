import 'package:flutter/material.dart';
import '../core/genFiles.dart';
import 'pageView.dart';
import 'package:buzz/ui/channelDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/ui/fabs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:buzz/ui/notificationMan.dart';
import 'package:buzz/ui/emptySpace.dart';
// import 'package:buzz/ui/errorHandler.dart';
import 'ads.dart';
import 'package:firebase_admob/firebase_admob.dart';

class InChannel extends StatelessWidget {
  final Firestore fstore = Firestore.instance;
  final String channelID;
  final bool isAdmin;
  // final BannerAd  banAd;
  InChannel({
    this.channelID,
    this.isAdmin,
  });

  final PageController pgc =
      PageController(initialPage: GenFiles.selectedIndex, keepPage: true);
  @override
  Widget build(BuildContext context) {
    // ErrorWidget.builder = (FlutterErrorDetails error) {
    //   ErrorUI().getErrorUI(context, error);
    // };
    // GenFiles.selectedIndex = 0;
    // GenFiles.selectedIndex = 0;
    // banAd.dispose();
    Ads.myBanner
      ..load()
      ..show(anchorType: AnchorType.bottom);

    BuzzNotification bz =
        BuzzNotification(channelID: channelID, context: context);
    bz.setUpNotification();

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: StreamBuilder(
            stream:
                fstore.collection('channels').document(channelID).snapshots(),
            builder: (builder, snapshot) {
              return Text(snapshot.data['channelName']);
            },
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChannelDashboard(
                        channelID: channelID, isAdmin: isAdmin)));
          },
        ),
        // backgroundColor: Color.fromRGBO(249, 249, 255, 1),
        backgroundColor: Color.fromRGBO(240, 240, 255, 1),

        elevation: 0,
      ),
      // body: Container(),
      body: MainPageView(channelID: channelID, pgc: pgc, bz: bz),
      floatingActionButton: (isAdmin)
          ? InchannelFab(
              channelID: channelID,
            )
          : EmptySpace(),
      bottomNavigationBar: Container(
          height: 118,
          child: Column(children: [
            BottomNavBar(pageController: pgc),
            Container(
            
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 1, color: Colors.grey)],
                // border: Border(top: BorderSide(width: 1, color: Colors.black)),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Colors.white
              ),
              height: 60,
              child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(children: [
                    Image(
                      height: 30,
                      image: AssetImage('assets/img/login_logo.png'),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Buzz 1.0 Coming Soon...',
                          style: TextStyle(fontSize: 15),
                        ))
                  ])),
            ),
          ])),
      // backgroundColor: Color.fromRGBO(249, 249, 255, 1),
      backgroundColor: Color.fromRGBO(240, 240, 255, 1),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final pageController;
  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      title: Text('Lectures'),
      icon: Icon(FontAwesomeIcons.chalkboardTeacher),
    ),
    BottomNavigationBarItem(
      title: Text('Courses'),
      icon: Icon(Icons.library_books),
    ),
    BottomNavigationBarItem(
      title: Text('Buzzes'),
      icon: Icon(FontAwesomeIcons.bell),
    )
  ];

  BottomNavBar({this.pageController});

  @override
  State<StatefulWidget> createState() {
    return BottomNavBarState(
        bottomNavBarItems: bottomNavItems, pageController: pageController);
  }
}

class BottomNavBarState extends State<BottomNavBar> {
  List<BottomNavigationBarItem> bottomNavBarItems;
  PageController pageController =
      PageController(initialPage: GenFiles.selectedIndex);

  BottomNavBarState({@required this.bottomNavBarItems, this.pageController});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: Color.fromRGBO(240, 240, 255, 1),

      // backgroundColor: Color.fromRGBO(249, 249, 255, 1),
      items: bottomNavBarItems,
      currentIndex: GenFiles.selectedIndex,
      selectedItemColor: Theme.of(context).accentColor,
      onTap: _onItemSelected,
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      debugPrint('tapped');
      GenFiles.selectedIndex = index;
      pageController.animateToPage(index,
          curve: Curves.easeOutSine, duration: Duration(milliseconds: 300));
    });
  }
}
