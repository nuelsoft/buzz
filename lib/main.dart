import 'package:flutter/material.dart';
import 'ui/channelList.dart';
import 'ui/fabs.dart';
import 'ui/makenjoin.dart';
import 'core/appTempData.dart';
import 'package:buzz/ui/drawerUI/drawerUI.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_ui/flutter_firebase_ui.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // // StreamSubscription<FirebaseUser> _listener;
  // FirebaseUser _currentUser;
  @override
  Widget build(BuildContext context) {
    // if (_currentUser == null) {
    //   return new SignInScreen(
    //     title: 'Buzz',
    //     avoidBottomInset: true,
    //     showBar: true,
    //     header: new Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 16.0),
    //       child: new Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: new Text("Demo"),
    //       ),
    //     ),
    //     providers: [
    //       ProvidersTypes.google,
    //       ProvidersTypes.email,
    //       ProvidersTypes.phone
    //     ],
    //     signUpPasswordCheck: true,
    //     color: Theme.of(context).accentColor,
    //     footer: Card(child: Text('Hello ')),
    //     padding: EdgeInsets.all(4),
    //   );
    // } else {
    return MaterialApp(
      title: 'Buzz',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(249, 249, 255, 1),
        primaryColorDark: Color.fromRGBO(249, 249, 255, 1),
        accentColor: Color.fromRGBO(00, 00, 255, 1),
      ),
      // routes: <String, WidgetBuilder>{
      //   '/enterChannel': (context) => InChannel(),
      // },
      home: AppHome(),
    );
  }
}
// }

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buzz'),
        elevation: 0,
        backgroundColor: Color.fromRGBO(240, 240, 255, 1),
      ),
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
      backgroundColor: Color.fromRGBO(240, 240, 255, 1),
      drawer: DrawerUI(),
    );
  }
}
