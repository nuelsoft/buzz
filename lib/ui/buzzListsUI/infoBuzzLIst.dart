import 'package:flutter/material.dart';
import 'buzzItemUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/buzz.dart';

class InfoBuzz extends StatelessWidget {
  final String channelID;
  final Firestore fstore = Firestore.instance;

  InfoBuzz({this.channelID});
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
                snapshot.data['buzz']['infoEntry'] == null) {
              return Center(
                child: Text('No Data at the moment'),
              );
            } else if (snapshot.data['buzz']['infoEntry'].length == 0) {
              return Center(
                child: Text('No records'),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                reverse: true,
                controller: sc,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data['buzz']['infoEntry'].length,
                itemBuilder: (context, index) {
                  return BuzzItem(
                    category: 0,
                    showCatAvatar: false,
                    buzz: Buzz(
                        author: snapshot.data['buzz']['info']
                                [snapshot.data['buzz']['infoEntry'][index]['title']]
                            ['author'],
                        category: 0,
                        msg: snapshot.data['buzz']['info']
                                [snapshot.data['buzz']['infoEntry'][index]['title']]['message'],
                        title: snapshot.data['buzz']['info']
                                [snapshot.data['buzz']['infoEntry'][index]['title']]['title'],
                        postTime: snapshot.data['buzz']['info']
                                [snapshot.data['buzz']['infoEntry'][index]['title']]['postTime'].toString(),
                        date: snapshot.data['buzz']['info']
                                [snapshot.data['buzz']['infoEntry'][index]['title']]['postDay'].toString()),
                  );
                },
              );
            }
        }
      },
    );
  }
}
