import 'package:flutter/material.dart';
import 'package:buzz/ui/profile.dart';
import 'package:buzz/ui/makeModalBottomSheet.dart';
import 'package:buzz/ui/joinModalBottomSheet.dart';
import 'package:buzz/ui/about.dart';
import 'package:buzz/ui/auth/portal/core.dart';
import 'package:buzz/core/appManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cache_image/cache_image.dart';
// import 'package:buzz/ui/emptySpace.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:buzz/main.dart';
import 'dart:io';
// import 'package:firebase_admob/firebase_admob.dart';
// import '';


class DrawerUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawerUIState();
  }
}

class DrawerUIState extends State<DrawerUI> {
  Firestore fstore = Firestore.instance;
  void launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppHome().showSnack('Install a Mail app to continue');
    }
  }

  bool hasInternet = false;
  Future<void> getInternetStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternet = true;
        print('has internet');
      }
    } on SocketException catch (_) {
      hasInternet = false;
      print('no internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    getInternetStatus();

    return Drawer(
      elevation: 2,
      child: Container(
        color: Colors.white,
        child: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: ClipOval(
                child: StreamBuilder(
              stream: fstore
                  .collection('userData')
                  .document(AppManager.myUserID)
                  .snapshots(),
              builder: (context, snapshot) {
                while (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  print(AppManager.dp);
                  return (AppManager.dp != null)
                      ? Image.network(
                          AppManager.dp,
                          fit: BoxFit.cover,
                          height: 80,
                        )
                      : Icon(
                          Icons.person,
                          size: 40,
                        );
                }
              },
            )),
            accountName: StreamBuilder(
              stream: fstore
                  .collection('userData')
                  .document(AppManager.myUserID)
                  .snapshots(),
              builder: (builder, snapshot) {
                return Text(
                    '${(snapshot.data['nickname'] == null) ? '@nonick' : "@" + snapshot.data['nickname']}\n${snapshot.data['name']}');
              },
            ),
            accountEmail: Text(AppManager.myEmail),
            onDetailsPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile()));
            },
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile()));
            },
            leading: Icon(Icons.account_circle,
                color: Color.fromRGBO(
                  100,
                  100,
                  100,
                  1,
                )),
            title: Text('Profile'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text('Channel',
                style: TextStyle(
                    fontSize: 15, color: Color.fromRGBO(100, 100, 100, 1))),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              getInternetStatus();
              if (!hasInternet) {
                AppHome().showSnack('Connect to the internet to Make channel');
                // Navigator.pop(context);
                return;
              }
              showModalBottomSheet(
                  context: context,
                  builder: (context) => MakeModalBottomSheet());
            },
            leading: Icon(
              Icons.create,
              color: Color.fromRGBO(
                100,
                100,
                100,
                1,
              ),
            ),
            title: Text('Make Channel'),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              getInternetStatus();
              if (!hasInternet) {
                AppHome().showSnack('Connect to the internet to Join channel');
                // Navigator.pop(context);
                return;
              }
              showModalBottomSheet(
                  context: context, builder: (context) => JoinChannelModal());
            },
            leading: Icon(Icons.person_add,
                color: Color.fromRGBO(
                  100,
                  100,
                  100,
                  1,
                )),
            title: Text('Join Channel'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text('Core',
                style: TextStyle(
                    fontSize: 15, color: Color.fromRGBO(100, 100, 100, 1))),
          ),
          // ListTile(
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     title: Text('Remove Ads'),
          //     leading: Icon(Icons.remove_circle,
          //         color: Color.fromRGBO(
          //           100,
          //           100,
          //           100,
          //           1,
          //         ))),
          // ListTile(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   title: Text('Settings'),
          //   leading: Icon(Icons.settings,
          //       color: Color.fromRGBO(
          //         100,
          //         100,
          //         100,
          //         1,
          //       )),
          // ),
          ListTile(
            onTap: () {
              const mail =
                  'mailto:buzz.mailapp@gmail.com?subject=Buzz%20App%20Review&body=My%20Review';
              launchUrl(mail);
              Navigator.pop(context);
            },
            title: Text('Review'),
            leading: Icon(Icons.rate_review,
                color: Color.fromRGBO(
                  100,
                  100,
                  100,
                  1,
                )),
          ),
          ListTile(
              title: Text('About'),
              leading: Icon(Icons.info,
                  color: Color.fromRGBO(
                    100,
                    100,
                    100,
                    1,
                  )),
              onTap: () {
                Navigator.pop(context);
                showDialog(context: context, builder: (_) => About());
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app,
                color: Color.fromRGBO(
                  100,
                  100,
                  100,
                  1,
                )),
            title: Text('Sign out'),
            onTap: () {
              AppManager.myUserID = '';
              AppManager.displayName= '';
              Navigator.pop(context);
              Auth().signOut();
            },
          )
        ]),
      ),
    );
  }
}
