import 'package:flutter/material.dart';

import '../../core/buzz.dart';
import '../emptySpace.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/core/appManager.dart';

class BuzzItem extends StatelessWidget {
  final bool showCatAvatar;
  final Buzz buzz;
  final int category;
  final String channelID;
  final bool all;
  final int index;

  BuzzItem(
      {this.buzz,
      this.showCatAvatar,
      this.category,
      this.all,
      this.channelID,
      this.index});

  Icon decideAvatar() {
    switch (category) {
      case 0:
        return Icon(FontAwesomeIcons.info,
            size: 100, color: Color.fromRGBO(20, 20, 255, 0.1));
      case 1:
        return Icon(Icons.event,
            size: 100, color: Color.fromRGBO(20, 20, 255, 0.1));
      case 2:
        return Icon(FontAwesomeIcons.poll,
            size: 100, color: Color.fromRGBO(20, 20, 255, 0.1));
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (_) {
              return (buzz.category == 0 || buzz.category == 1)
                  ? (buzz.category == 0)
                      ? GeneralPurpose(
                          info: true,
                          author: buzz.author,
                          message: buzz.msg,
                          postDay: buzz.date,
                          postTime: buzz.postTime,
                          // proposedTime: proposedTime,
                          title: buzz.title,
                        )
                      : GeneralPurpose(
                          info: false,
                          author: buzz.author,
                          message: buzz.msg,
                          postTime: buzz.postTime,
                          postDay: buzz.date,
                          proposedTime: buzz.proposedTime,
                          title: buzz.title,
                        )
                  : PollExpand(
                      channelID: channelID,
                      title: buzz.title,
                    );
            });
      },
      child: Stack(children: [
        (showCatAvatar)
            ? Align(
                alignment: Alignment.centerRight,
                child: decideAvatar(),
              )
            : EmptySpace(),
        Padding(
          padding: EdgeInsets.all(8),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Text(buzz.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            ),
            Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '"',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                            child: Text(
                          buzz.msg,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.fade,
                        ))
                      ],
                    )),
              ],
            ),
            Row(children: <Widget>[
              (category == 1)
                  ? Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 15,
                            color: Color.fromRGBO(110, 110, 110, 1),
                          ),
                          Text(
                            buzz.venue,
                            // style: TextStyle(
                            //     fontSize: 17, fontWeight: FontWeight.w400),
                          )
                        ],
                      ))
                  : EmptySpace(),
              (category != 0)
                  ? Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            size: 15,
                            color: Color.fromRGBO(110, 110, 110, 1),
                          ),
                          Text(
                            buzz.proposedTime,
                            // style: TextStyle(
                            //     fontSize: 17, fontWeight: FontWeight.w400),
                          )
                        ],
                      ))
                  : EmptySpace()
            ]),
            Padding(
                padding: EdgeInsets.only(top: 4, left: 8, right: 4),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Published by ',
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "${buzz.author}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 2, right: 2),
                            child: Text('~',
                                style: TextStyle(fontWeight: FontWeight.w300))),
                        Text(
                          buzz.postTime,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic),
                        ),
                        (buzz.date != null)
                            ? Padding(
                                padding: EdgeInsets.only(left: 2, right: 2),
                                child: Text('~',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)))
                            : EmptySpace(),
                        (buzz.date != null)
                            ? Text(
                                buzz.date,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic),
                              )
                            : EmptySpace(),
                      ],
                    )
                  ],
                )),
            Divider(height: 15)
          ]),
        ),
      ]),
    );
  }
}

class PollExpand extends StatefulWidget {
  final String title;
  final String channelID;
  final Firestore fstore = Firestore.instance;

  PollExpand({
    this.title,
    this.channelID,
  });

  @override
  _PollExpandState createState() => _PollExpandState();
}

class _PollExpandState extends State<PollExpand> {
  bool enableVote = true;
  String unableMessage;
  Firestore fstore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        height: 300,
        child: StreamBuilder(
          stream: widget.fstore
              .collection('channels')
              .document(widget.channelID)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.data['buzz']['polls'] != null) {
                  if (Timestamp.now().compareTo(snapshot.data['buzz']['polls']
                          [widget.title]['endDate']) >
                      0) {
                    enableVote = false;
                    unableMessage = 'Voting Ended';
                  } else if (snapshot.data['buzz']['polls'][widget.title]
                              ['startDate']
                          .compareTo(Timestamp.now()) >
                      0) {
                    enableVote = false;
                    unableMessage = 'Voting hasn\'t started yet';
                  } else if (snapshot
                          .data['buzz']['polls'][widget.title]['voters']
                          .length !=
                      0) {
                    if (snapshot.data['buzz']['polls'][widget.title]['voters']
                        .contains(AppManager.myUserID)) {
                      enableVote = false;
                      unableMessage = 'You can\'t vote again';
                    }
                  }
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16, right: 8),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              snapshot.data['buzz']['polls'][widget.title]
                                      ['title'] +
                                  ' ~ Poll',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2, right: 8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                              ' ${snapshot.data['buzz']['polls'][widget.title]['proposedTime']}'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2, right: 8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                              ' ${snapshot.data['buzz']['polls'][widget.title]['voters'].length.toString() + ((snapshot.data['buzz']['polls'][widget.title]['voters'].length != 1) ? ' votes' : ' vote')}'),
                        ),
                      ),
                      (enableVote)
                          ? EmptySpace()
                          : Padding(
                              padding: EdgeInsets.only(top: 16, left: 16),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    unableMessage,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                      Container(
                          // color: Colors.black,
                          height: 200,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot
                                .data['buzz']['polls'][widget.title]
                                    ['pollOptions']
                                .length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                color: Color.fromRGBO(240, 240, 255, 1),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  snapshot.data['buzz']['polls']
                                                              [widget.title]
                                                          ['pollOptions'][index]
                                                      ['title'],
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 20)),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  '"' +
                                                      snapshot.data['buzz']
                                                                      ['polls']
                                                                  [widget.title]
                                                              ['pollOptions']
                                                          [index]['manifestoe'],
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            (enableVote)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      snapshot.data['buzz']['polls'][widget.title]['optionVotes']
                                                                      [snapshot.data['buzz']['polls'][widget.title]['pollOptions'][index]['pollOptionID']]
                                                                  ['votes']
                                                              .toString() +
                                                          ((snapshot.data['buzz']['polls']
                                                                          [widget.title]
                                                                      ['optionVotes'][snapshot.data['buzz']['polls'][widget.title]['pollOptions']
                                                                          [index]
                                                                      ['pollOptionID']]['votes'] !=
                                                                  1)
                                                              ? ' votes'
                                                              : ' vote'),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  )
                                                : EmptySpace(),
                                          ]),
                                      (enableVote)
                                          ? RaisedButton(
                                              color:
                                                  Theme.of(context).accentColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              onPressed: () {
                                                fstore
                                                    .collection('channels')
                                                    .document(widget.channelID)
                                                    .setData({
                                                  'buzz': {
                                                    'polls': {
                                                      widget.title: {
                                                        'voters': FieldValue
                                                            .arrayUnion([
                                                          AppManager.myUserID
                                                        ])
                                                      }
                                                    }
                                                  }
                                                }, merge: true);
                                                fstore
                                                    .collection('channels')
                                                    .document(widget.channelID)
                                                    .setData({
                                                  'buzz': {
                                                    'polls': {
                                                      widget.title: {
                                                        'optionVotes': {
                                                          snapshot.data['buzz'][
                                                                          'polls']
                                                                      [
                                                                      widget
                                                                          .title]
                                                                  [
                                                                  'pollOptions'][index]
                                                              [
                                                              'pollOptionID']: {
                                                            'votes': snapshot.data['buzz']
                                                                            ['polls']
                                                                        [widget.title]
                                                                    ['optionVotes'][snapshot.data['buzz']
                                                                            ['polls']
                                                                        [widget
                                                                            .title]['pollOptions'][index]
                                                                    ['pollOptionID']]['votes'] +
                                                                1
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                }, merge: true);

                                                // print(snapshot.data['buzz']['polls'][widget.title]['voters'].length.toString());
                                              },
                                              child: Text(
                                                'Vote',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : Card(
                                              color: Colors.grey,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              child: Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                  snapshot.data['buzz']['polls']
                                                                          [widget.title]
                                                                      ['optionVotes']
                                                                  [snapshot.data['buzz']['polls'][widget.title]['pollOptions'][index]['pollOptionID']]
                                                              ['votes']
                                                          .toString() +
                                                      ((snapshot.data['buzz']
                                                                              ['polls']
                                                                          [widget.title]
                                                                      ['optionVotes']
                                                                  [snapshot.data['buzz']['polls'][widget.title]['pollOptions'][index]['pollOptionID']]['votes'] !=
                                                              1)
                                                          ? ' votes'
                                                          : ' vote'),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                    ],
                  );
                }
            }
          },
        ));
  }
}

class GeneralPurpose extends StatelessWidget {
  final bool info;
  final String title;
  final String message;
  final String author;
  final String postTime;
  final String postDay;
  final String proposedTime;
  GeneralPurpose(
      {this.info,
      this.title,
      this.message,
      this.postDay,
      this.author,
      this.postTime,
      this.proposedTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      height: 300,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16, right: 8),
            child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  title + " ~ " + ((info) ? 'Info' : 'Event'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                )),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 8, left: 16, bottom: 2),
              child: Icon(FontAwesomeIcons.quoteLeft),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
            child: Text(message),
          ),
          (!info)
              ? Padding(
                  padding:
                      EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                  child: Row(children: [
                    Icon(Icons.access_time),
                    Padding(
                      child: Text(proposedTime),
                      padding: EdgeInsets.only(left: 8),
                    )
                  ]),
                )
              : EmptySpace(),
          Padding(
            padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
            child: Text('Published by ' +
                author +
                ', at ' +
                postTime +
                ' ~ ' +
                postDay),
          )
        ],
      ),
    );
    // : EmptySpace();
  }
}
