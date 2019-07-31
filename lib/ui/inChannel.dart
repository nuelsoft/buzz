import 'package:flutter/material.dart';
import '../core/genFiles.dart';
import 'pageView.dart';
import 'package:buzz/ui/channelDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/ui/fabs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InChannel extends StatelessWidget {
  final Firestore fstore = Firestore.instance;
  final String channelID;
  InChannel({this.channelID});

  final PageController pgc = PageController(initialPage: 0, keepPage: true);
  @override
  Widget build(BuildContext context) {
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
                    builder: (context) =>
                        ChannelDashboard(channelID: channelID)));
          },
        ),
        // backgroundColor: Color.fromRGBO(249, 249, 255, 1),
        backgroundColor: Color.fromRGBO(240, 240, 255, 1),

        elevation: 0,
      ),
      // body: Container(),
      body: MainPageView(channelID: channelID, pgc: pgc),
      floatingActionButton: InchannelFab(
        channelID: channelID,
      ),
      bottomNavigationBar: BottomNavBar(pageController: pgc),
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
  final PageController pageController;

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
