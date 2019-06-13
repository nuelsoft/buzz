import 'package:flutter/material.dart';
import 'package:buzz/ui/profile.dart';

class DrawerUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawerUIState();
  }
}

class DrawerUIState extends State<DrawerUI> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      child: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
        UserAccountsDrawerHeader(
          currentAccountPicture: ClipOval(
              child:
                  // Image.asset('../../../images/yot.jpg', height: 100, width: 100, color: Colors.green,),
                  Image.network(
                      'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=format%2Ccompress&cs=tinysrgb&dpr=2&h=650&w=940',
                      fit: BoxFit.cover)),
          accountName: Text('@nuel \nEmmanuel Sunday'),
          accountEmail: Text('nuel.mailbox@gmail.com'),
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
          leading: Icon(Icons.account_circle),
          title: Text('Profile'),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text('Channel', style: TextStyle(fontSize: 15, color: Color.fromRGBO(100, 100, 100, 1))),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          leading: Icon(Icons.create),
          title: Text('Create Channel'),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          leading: Icon(Icons.person_add),
          title: Text('Join Channel'),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text('Core', style: TextStyle(fontSize: 15,  color: Color.fromRGBO(100, 100, 100, 1))),
        ),
        ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text('Remove Ads'),
            leading: Icon(Icons.remove_circle)),
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          title: Text('Settings'),
          leading: Icon(Icons.settings),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
          },
          title: Text('Review'),
          leading: Icon(Icons.rate_review),
        ),
        ListTile(
            title: Text('About'),
            leading: Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
            }),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Sign out'),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ]),
    );
  }
}
