import 'package:flutter/material.dart';
import '../core/appTempData.dart';
import 'pageView.dart';

class InChannel extends StatelessWidget {
  final int index;

  InChannel({@required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppTempData.channels[index].channelTitle)),
      body: MainPageView(channelIndex: index),
      bottomNavigationBar: BottomNavBar(),
      backgroundColor: Color.fromRGBO(225, 225, 225, 1),
    );
  }
}

class BottomNavBar extends StatefulWidget {
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

  @override
  State<StatefulWidget> createState() {
    return BottomNavBarState(bottomNavBarItems: bottomNavItems);
  }
}

class BottomNavBarState extends State<BottomNavBar> {
  List<BottomNavigationBarItem> bottomNavBarItems;
  int _selectedIndex = 0;

  BottomNavBarState({@required this.bottomNavBarItems});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: bottomNavBarItems,
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).accentColor,
      onTap: _onItemSelected,
    );
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
 
