import 'package:flutter/material.dart';
import 'ui/channelList.dart';
import 'ui/fabs.dart';
import 'ui/makenjoin.dart';
import 'core/appManager.dart';
import 'package:buzz/ui/drawerUI/drawerUI.dart';
import 'package:buzz/ui/auth/master.dart';
import 'package:buzz/ui/auth/portal/core.dart';

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

  @override
  void initState() {
    if (AppManager.firebaseUser != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(milliseconds: 2000),
        content: Container(
            child: Center(
                child: Text(
                    'Signed in as ${AppManager.firebaseUser.displayName}'))),
      ));
    } else {
      Auth().signOut();
    }
    super.initState();
  }

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
}
