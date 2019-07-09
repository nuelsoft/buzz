import 'package:flutter/material.dart';
import '../core/appTempData.dart';
import '../core/genFiles.dart';
import 'pageView.dart';
import 'package:buzz/ui/channelDashboard.dart';

class InChannel extends StatelessWidget {
  final int index;

  InChannel({@required this.index});

  final PageController pgc = PageController(initialPage: 0, keepPage: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(AppTempData.channels[index].channelTitle),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChannelDashboard(
                          channel: AppTempData.channels[index],
                        )));
          },
        ),
        // backgroundColor: Color.fromRGBO(249, 249, 255, 1),
        backgroundColor: Color.fromRGBO(240, 240, 255, 1),

        elevation: 0,
      ),
      body: MainPageView(channelIndex: index, pgc: pgc),
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
      icon: Icon(Icons.insert_chart),
    ),
    BottomNavigationBarItem(
      title: Text('Courses'),
      icon: Icon(Icons.library_books),
    ),
    BottomNavigationBarItem(
      title: Text('Buzzes'),
      icon: Icon(Icons.alarm),
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
