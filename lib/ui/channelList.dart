import 'package:flutter/material.dart';
import '../core/channel.dart';
import 'notifyCard.dart';
import '../core/appTempData.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'inChannel.dart';

class ChannelList extends StatefulWidget {
  final List<Channel> channels;

  ChannelList({this.channels});

  @override
  State<StatefulWidget> createState() {
    return ChannelListState(channels: channels);
  }
}

class ChannelListState extends State<ChannelList> {
  List<Channel> channels;

  ChannelListState({this.channels});

  @override
  Widget build(BuildContext context) {
    return ((channels != null || channels.length > 0))
        ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: channels.length,
            itemBuilder: (context, index) {
              return ChannelEntry(
                  channelTitle: channels[index].channelTitle,
                  channelId: channels[index].channelId,
                  base: channels[index].channelBase,
                  members: channels[index].channelMembers,
                  currentBuzzes: channels[index].myCurrentBuzzes,
                  index: index);
            })
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[Icon(FontAwesomeIcons.chalkboard), Text('No Channels yet!')],
          ));
  }
}

class ChannelEntry extends StatefulWidget {
  final String channelTitle, channelId, base;
  final int members, currentBuzzes, index;
  ChannelEntry(
      {this.channelTitle,
      this.channelId,
      this.base,
      this.members,
      this.currentBuzzes,
      @required this.index});

  @override
  State<StatefulWidget> createState() {
    return ChannelEntryState(
        index: index,
        channelTitle: channelTitle,
        channelId: channelId,
        base: base,
        members: members,
        currentBuzzes: currentBuzzes);
  }
}

class ChannelEntryState extends State<ChannelEntry> {
  String channelTitle, channelId, base;
  int members, currentBuzzes, index;

  ChannelEntryState(
      {this.channelTitle,
      this.channelId,
      this.base,
      this.members,
      this.currentBuzzes,
      @required this.index});

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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InChannel(
                            index: index,
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
                          height: 210,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 16, left: 16),
                                  child: Text(
                                    '$channelTitle',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  )),
                              ListTile(
                                leading: Icon(Icons.delete,
                                    color: Color.fromRGBO(
                                      100,
                                      100,
                                      100,
                                      1,
                                    )),
                                title: Text('Leave and Delete Channel'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.notifications_off,
                                    color: Color.fromRGBO(
                                      100,
                                      100,
                                      100,
                                      1,
                                    )),
                                title: Text('Mute Channel'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
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
                            Text(
                              channelId.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
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
                                    Text(base),
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
                                Text((members).toString() + " classmates")
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
