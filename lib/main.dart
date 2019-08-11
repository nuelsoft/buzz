import 'package:flutter/material.dart';
import 'package:buzz/ui/channelList.dart';
import 'package:buzz/ui/fabs.dart';
import 'package:buzz/ui/makenjoin.dart';
import 'package:buzz/core/appManager.dart';
import 'package:buzz/ui/drawerUI/drawerUI.dart';
import 'package:buzz/ui/auth/master.dart';
import 'package:buzz/ui/auth/portal/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:buzz/ui/ads.dart';
// import 'package:buzz/ui/errorHandler.dart';

void main() {
  FirebaseAdMob.instance
      .initialize(appId: 'ca-app-pub-5714629379881538~1301729415');
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buzz',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(230, 230, 255, 1),
        primaryColorDark: Color.fromRGBO(249, 249, 255, 1),
        accentColor: Color.fromRGBO(00, 00, 255, 1),
        // canvasColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'WorkSansMedium',
      ),

      home: IsUser(appHome: AppHome()),
      // debugShowCheckedModeBanner: false,
    );
  }
}

class AppHome extends StatefulWidget {
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showSnack(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text(msg),
    ));
  }

  @override
  _AppHomeState createState() => _AppHomeState(scaffoldKey: _scaffoldKey);
}

class _AppHomeState extends State<AppHome> {
  final GlobalKey<ScaffoldState> scaffoldKey;
  BannerAd myBanner;

  _AppHomeState({this.scaffoldKey});
  Firestore fstore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    // ErrorWidget.builder = (FlutterErrorDetails error) {
    //   ErrorUI().getErrorUI(context, error);
    // };
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Buzz'),
        elevation: 0,
        backgroundColor: Color.fromRGBO(240, 240, 255, 1),
      ),
      body: Container(
        child: ChannelList(),
      ),
      floatingActionButton: Fab(
        icon: Icon(Icons.add),
        func: () {
          // Ads.myBanner.load();
          showModalBottomSheet(context: context, builder: (_) => MakeNJoin());
        },
        tooltip: 'Toogle add channel',
      ),
      backgroundColor: Color.fromRGBO(240, 240, 255, 1),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 4, spreadRadius: 1, color: Colors.grey)
          ],
          // border: Border(top: BorderSide(width: 1, color: Colors.black)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white,
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
      drawer: DrawerUI(),
    );
  }

  @override
  void initState() {
    Ads().adsInstantiate();
    Ads.myBanner
      ..load()
      ..show(anchorType: AnchorType.bottom);

    Future<String> future = Auth().getCurrentUser();

    future.then((userId) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(milliseconds: 1000),
        backgroundColor: Colors.grey[700],
        content: Padding(
            padding: EdgeInsets.all(4),
            child: StreamBuilder(
              stream:
                  fstore.collection('userData').document(userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data['name'] != null) {
                  AppManager.displayName = snapshot.data['name'];
                  return Text('Signed in as ${snapshot.data['name']}');
                } else {
                  return Text('Loading User');
                }
              },
            )),
      ));
    });
    super.initState();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }
}
