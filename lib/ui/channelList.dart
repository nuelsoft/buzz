import 'package:flutter/material.dart';
// import '../core/channel.dart';
import 'notifyCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'inChannel.dart';
import 'package:buzz/core/appManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
// import 'package:buzz/ui/ads.dart';
// import 'package:firebase_admob/firebase_admob.dart';
// import 'package:buzz/ui/errorHandler.dart';

class ChannelList extends StatefulWidget {
  // final List<Channel> channels;

  @override
  State<StatefulWidget> createState() {
    return ChannelListState();
  }
}

class ChannelListState extends State<ChannelList> {
  // List<Channel> channels;

  Firestore fstore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    // ErrorWidget.builder = (FlutterErrorDetails error) {
    //   ErrorUI().getErrorUI(context, error);
    // };
    return StreamBuilder(
      stream: fstore
          .collection('userData')
          .document(AppManager.myUserID)
          .snapshots(),
      builder: (builder, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data['channels'] != null) {
                if (snapshot.data['channels'].length != 0) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data['channels'].length,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                        stream: fstore
                            .collection('channels')
                            .document(snapshot.data['channels'][index])
                            .snapshots(),
                        builder: (cardBuilder, cardSnapshot) {
                          if (cardSnapshot.hasData &&
                              cardSnapshot.data != null) {
                            return ChannelEntry(
                                isAdmin: cardSnapshot.data['users']
                                    [AppManager.myUserID]['isAdmin'],
                                channelTitle: cardSnapshot.data['channelName'],
                                channelId: cardSnapshot.data['channelId'],
                                base: cardSnapshot.data['institution'],
                                members: cardSnapshot.data['users'].length,
                                currentBuzzes: cardSnapshot
                                        .data['currentNotifications'] -
                                    snapshot.data['channelLog']
                                            [snapshot.data['channels'][index]]
                                        ['currentNotifications']
                                // cardSnapshot.data['currentNotifications'])
                                );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.chalkboard,
                        size: 55,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 5, left: 15),
                          child: Text('No Channels found'))
                    ],
                  ));
                }
              } else {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.chalkboard,
                      size: 55,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 5, left: 15),
                        child: Text('No Channels found'))
                  ],
                ));
              }
            } else {
              return Center(
                child: Text('Getting things ready'),
              );
            }
        }
      },
    );
  }
}

class ChannelEntry extends StatefulWidget {
  final String channelTitle, channelId, base;
  final int members, currentBuzzes;
  final bool isAdmin;
  ChannelEntry({
    this.isAdmin,
    this.channelTitle,
    this.channelId,
    this.base,
    this.members,
    this.currentBuzzes,
  });

  @override
  State<StatefulWidget> createState() {
    return ChannelEntryState(
        channelTitle: channelTitle,
        channelId: channelId,
        base: base,
        members: members,
        currentBuzzes: currentBuzzes);
  }
}

class ChannelEntryState extends State<ChannelEntry> {
  String channelTitle, channelId, base;
  int members, currentBuzzes;

  ChannelEntryState({
    this.channelTitle,
    this.channelId,
    this.base,
    this.members,
    this.currentBuzzes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 1, left: 2, right: 2),
        child: Card(
          color: Color.fromRGBO(238, 238, 255, 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          elevation: 0,
          child: RaisedButton(
            highlightColor: Color.fromRGBO(239, 239, 255, 1),
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            onPressed: () {
              // Ads.myBanner.dispose();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InChannel(
                            isAdmin: widget.isAdmin,
                            channelID: channelId,
                          )));
            },
            color: Colors.white,
            padding: EdgeInsets.all(4),
            child: GestureDetector(
              onLongPress: () {
                showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15))),
                          height: 170,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                    right: 10,
                                  ),
                                  child: Text(
                                    '$channelTitle',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  )),
                              ListTile(
                                leading: Icon(Icons.content_copy,
                                    color: Color.fromRGBO(
                                      100,
                                      100,
                                      100,
                                      1,
                                    )),
                                title: Text('Copy Channel ID'),
                                onTap: () {
                                  ClipboardManager.copyToClipBoard("$channelId")
                                      .then((result) {
                                    final snackBar = SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text('Copied to Clipboard'),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  });
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ));
              },
              child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('ID:  ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w100,
                                        fontStyle: FontStyle.italic)),
                                Text(
                                  channelId.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            NotifyCard(unSeen: currentBuzzes),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                              child: Text(
                            channelTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                            ),
                          )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(4),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                      size: 17,
                                    ),
                                    Container(
                                        width: 90,
                                        child: Text(
                                          base,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: Row(children: <Widget>[
                                Icon(
                                  Icons.people,
                                  color: Colors.grey,
                                  size: 17,
                                ),
                                Text(
                                  (members == 0)
                                      ? 'No Members'
                                      : (members).toString() + " classmates",
                                  overflow: TextOverflow.ellipsis,
                                )
                              ]),
                            )
                          ],
                        ),
                      ])),
            ),
          ),
        ));
  }
}
