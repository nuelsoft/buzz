import 'package:flutter/material.dart';
import 'package:buzz/core/channel.dart';
// import 'package:buzz/core/buzzUser.dart';
import 'package:buzz/ui/person.dart';
// import 'package:buzz/ui/auth/master.dart';

class ChannelDashboard extends StatefulWidget {
  final String channelID;

  ChannelDashboard({this.channelID});
  @override
  State<StatefulWidget> createState() {
    return ChannelDashboardState(channelID: channelID);
  }
}

class ChannelDashboardState extends State<ChannelDashboard> {
  final String channelID;
  ChannelDashboardState({this.channelID});
  bool _switchVal = false;

  _switchOnChange(bool value) {
    setState(() {
      _switchVal = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Color.fromRGBO(235, 235, 255, 1),
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.delete))
                ],
                expandedHeight: 190,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: 
                  Text(
                    // channel.channelTitle,
                    // style: TextStyle(fontSize: 18),
                    // overflow: TextOverflow.fade,
                  'hi'
                  ),
                  background: Image.network(
                    'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=format%2Ccompress&cs=tinysrgb&dpr=2&h=650&w=940',
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ];
          },
          body: Card(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 16, bottom: 8),
                  child: Row(children: [
                    Text(
                      'Made by ',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    Text(
                      'Benjamin Kayode',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )
                  ]),
                ),
                Divider(),
                ListTile(
                  onTap: () {},
                  title: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child:
                            Text('Description', style: TextStyle(fontSize: 12)),
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              'Buzz Channel for all loosers and suckers and fools')),
                    ],
                  ),
                ),
                SwitchListTile(
                  value: _switchVal,
                  title: Text('Mute Birthday Notifications'),
                  onChanged: _switchOnChange,
                ),
                ListTile(
                  enabled: _switchVal,
                  title: Text('Mute Notifications Except'),
                ),
                Divider(),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'Members',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w400),
                      ),
                    )),
                // (channel.users != null && channel.users.length > 0)
                //     ? ListView.builder(
                //         itemCount: channel.users.length,
                //         itemBuilder: (context, index) {
                //           PersonItem(buzzUser: channel.users[index]);
                //         })
                //     : Center(child: Text('No Members'))
              ]),
            ),
          )),
      backgroundColor: Color.fromRGBO(235, 235, 255, 1),
    );
  }
}
