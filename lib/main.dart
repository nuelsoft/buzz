import 'package:flutter/material.dart';
import 'ui/channelList.dart';
import 'ui/fabs.dart';
import 'ui/makenjoin.dart';
import 'core/appManager.dart';
import 'package:buzz/ui/drawerUI/drawerUI.dart';
import 'package:buzz/ui/auth/master.dart';
import 'package:buzz/ui/auth/portal/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buzz',
      theme: ThemeData(
          primaryColor: Color.fromRGBO(230, 230, 255, 1),
          primaryColorDark: Color.fromRGBO(249, 249, 255, 1),
          accentColor: Color.fromRGBO(00, 00, 255, 1),
          canvasColor: Colors.transparent,
          fontFamily: 'WorkSansMedium'),
      home: IsUser(appHome: AppHome()),
      // debugShowCheckedModeBanner: false,
    );
  }
}
// }

class AppHome extends StatefulWidget {
  @override
  _AppHomeState createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Firestore fstore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Buzz'),
        elevation: 0,
        backgroundColor: Color.fromRGBO(240, 240, 255, 1),
      ),
      body: Container(
        child: ChannelList(
          channels: AppManager.channels,
        ),
      ),
      floatingActionButton: Fab(
        icon: Icon(Icons.add),
        func: () {
          showModalBottomSheet(context: context, builder: (_) => MakeNJoin());
        },
        tooltip: 'Toogle add channel',
      ),
      backgroundColor: Color.fromRGBO(240, 240, 255, 1),
      drawer: DrawerUI(),
    );
  }

  @override
  void initState() {
    Future<String> future = Auth().getCurrentUser();

    future.then((userId) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(milliseconds: 1000),
        backgroundColor: Colors.grey[700],
        content: Padding(
            padding: EdgeInsets.all(4),
            child: StreamBuilder(
              stream:
                  fstore.collection('userData').document(userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data['name'] != null) {
                  return Text('Signed in as ${snapshot.data['name']}');
                }else {
                  return Text('Loading User');
                }
              },
            )),
      ));
    });
    super.initState();
  }
}
