import 'package:flutter/material.dart';
import 'ui/channelList.dart';
import 'ui/fabs.dart';
import 'ui/makenjoin.dart';
import 'core/appTempData.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buzz',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.brown,
      ),
      // routes: <String, WidgetBuilder>{
      //   '/enterChannel': (context) => InChannel(),
      // },
      home: AppHome(),
    );
  }
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buzz')),
      body: Container(
        child: ChannelList(
          channels: AppTempData.channels,
        ),
      ),
      floatingActionButton: Fab(
        icon: Icon(Icons.add),
        func: () {
          showDialog(context: context, builder: (_) => MakeNJoin());
        },
        tooltip: 'Toogle add channel',
      ),
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
    );
  }
}
