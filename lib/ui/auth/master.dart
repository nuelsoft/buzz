import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buzz/ui/splash.dart';
// import 'package:buzz/main.dart';
import 'package:buzz/ui/auth/portal/core.dart';
import 'package:buzz/ui/auth/portal/ui/login_page.dart';
import 'package:buzz/core/appManager.dart';
// import 'package:url_launcher/url_launcher.dart';

class IsUser extends StatelessWidget {
  // void launchUrl(url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   }
  // }

  final Widget appHome;
  IsUser({this.appHome});
  @override
  Widget build(BuildContext context) {
    // return (false)
    //     ? Scaffold(
    //         body: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Text('This version of Buzz is no longer supported!'),
    //             RaisedButton(
    //               child: Text('Get the Latest Version'),
    //               color: Color.fromRGBO(0, 0, 255, 1),
    //               onPressed: () {
    //                 launchUrl('url');
    //               },
    //             ),
    //           ],
    //         ),
    //       )
    //     : 
        return StreamBuilder<FirebaseUser>(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (BuildContext context, snapshot) {
              Auth().getCurrentUser();

              return (snapshot.connectionState == ConnectionState.waiting)
                  ? SplashScreen()
                  : (snapshot.hasData)
                      ? (AppManager.myUserID == null)
                          ? StreamBuilder(
                              stream: Auth().getCurrentUser().asStream(),
                              builder: (ctx, snp) {
                                while (snp.data == null) {
                                  return SplashScreen();
                                }
                                AppManager.myUserID = snp.data;
                                Auth().getCurrentUser();
                                return appHome;
                              })
                          : appHome
                      : LoginPage();
            },
          );
  }
}
