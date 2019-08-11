import 'package:flutter/material.dart';
import 'package:buzz/ui/buzzListsUI/buzzItemUI.dart';
import 'package:buzz/core/buzz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PollBuzz extends StatelessWidget {
  final String channelID;
  final Firestore fstore = Firestore.instance;
  PollBuzz({this.channelID});
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
                  snapshot.data['buzz']['pollsEntry'] == null) {
                return Center(
                  child: Text('No Polls at the moment'),
                );
              } else if (snapshot.data['buzz']['pollsEntry'].length == 0) {
                return Center(
                  child: Text('No records'),
                );
              } else {
                return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  controller: sc,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data['buzz']['pollsEntry'].length,
                  itemBuilder: (context, index) {
                    return BuzzItem(
                      category: 2,
                      showCatAvatar: true,
                      buzz: Buzz(
                        author: snapshot.data['buzz']['polls'][
                            snapshot.data['buzz']['pollsEntry'][index]
                                ['title']]['author'],
                        category: 2,
                        msg: 'Your vote counts!',
                        title: snapshot.data['buzz']['pollsEntry'][index]
                            ['title'],
                        postTime: snapshot.data['buzz']['polls'][
                                snapshot.data['buzz']['pollsEntry'][index]
                                    ['title']]['postTime']
                            .toString(),
                        date: snapshot.data['buzz']['polls'][
                                snapshot.data['buzz']['pollsEntry'][index]
                                    ['title']]['postDay']
                            .toString(),
                        proposedTime: snapshot.data['buzz']['polls'][
                            snapshot.data['buzz']['pollsEntry'][index]
                                ['title']]['proposedTime'],
                        // venue: snapshot.data['buzz']['event'][index]
                        //     ['venue']
                      ),
                      all: false,
                      channelID: channelID,
                      index: index,
                    );
                  },
                );
              }
          }
        });
  }
}
