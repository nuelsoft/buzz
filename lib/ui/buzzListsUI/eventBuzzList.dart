import 'package:flutter/material.dart';
import 'package:buzz/core/buzz.dart';
import 'package:buzz/ui/buzzListsUI/buzzItemUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventBuzz extends StatelessWidget {
  final String channelID;
  final Firestore fstore = Firestore.instance;
  EventBuzz({this.channelID});
    ScrollController sc = ScrollController(initialScrollOffset: 100000);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fstore.collection('channels').document(channelID).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (!snapshot.hasData ||
                  snapshot.data['buzz'] == null ||
                  snapshot.data['buzz']['eventEntry'] == null) {
                return Center(
                  child: Text('No Data at the moment'),
                );
              } else if (snapshot.data['buzz']['eventEntry'].length == 0) {
                return Center(
                  child: Text('No records'),
                );
              } else {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data['buzz']['eventEntry'].length,
                  reverse: true,
                  shrinkWrap: true,
                  controller: sc,
                  itemBuilder: (context, index) {
                    return BuzzItem(
                      category: 1,
                      showCatAvatar: false,
                      buzz: Buzz(
                          author: snapshot.data['buzz']['event'][snapshot.data['buzz']['eventEntry'][index]['title']]['author'],
                          category: snapshot.data['buzz']['event']
                                  [snapshot.data['buzz']['eventEntry'][index]['title']]
                              ['category'],
                          msg: snapshot.data['buzz']['event']
                                  [snapshot.data['buzz']['eventEntry'][index]['title']]
                              ['message'],
                          title: snapshot.data['buzz']['event']
                                  [snapshot.data['buzz']['eventEntry'][index]['title']]
                              ['title'],
                          postTime: snapshot.data['buzz']['event'][snapshot.data['buzz']['eventEntry'][index]['title']]['postTime'].toString(),
                          date: snapshot.data['buzz']['event'][snapshot.data['buzz']['eventEntry'][index]['title']]['postDay'].toString(),
                          proposedTime: snapshot.data['buzz']['event'][snapshot.data['buzz']['eventEntry'][index]['title']]['proposedTime'],
                          venue: snapshot.data['buzz']['event'][snapshot.data['buzz']['eventEntry'][index]['title']]['venue']),
                    );
                  },
                );
              }
          }
        });
  }
}
