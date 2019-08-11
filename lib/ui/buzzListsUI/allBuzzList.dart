import 'package:flutter/material.dart';
import 'package:buzz/core/buzz.dart';
import 'package:buzz/ui/buzzListsUI/buzzItemUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllBuzz extends StatefulWidget {
  final String channelID;
  AllBuzz({this.channelID});

  @override
  _AllBuzzState createState() => _AllBuzzState();
}

class _AllBuzzState extends State<AllBuzz> {
  final Firestore fstore = Firestore.instance;

  final ScrollController sc = ScrollController(initialScrollOffset: 1000000);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fstore.collection('channels').document(widget.channelID).snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (!snapshot.hasData ||
                snapshot.data['buzz'] == null ||
                snapshot.data['buzz']['all'] == null) {
              return Center(
                child: Text('No Data at the moment'),
              );
            } else if (snapshot.data['buzz']['all'].length == 0) {
              return Center(
                child: Text('No records'),
              );
            } else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: sc,
                reverse: true,
                shrinkWrap: true,
                itemCount: snapshot.data['buzz']['all'].length,
                itemBuilder: (context, index) {
                  // if(snapshot.data['buzz']['all'].length - index == 1){
                  //   sc.animateTo(sc.position.maxScrollExtent, curve: Curves.ease, duration: Duration(seconds: 1));
                  //   print(true);
                  // }
                  return BuzzItem(
                    category: snapshot.data['buzz'][snapshot.data['buzz']
                                    ['all'][index]['from']]
                                [snapshot.data['buzz']['all'][index]['title']]['category'],
                    showCatAvatar: true,
                    buzz: Buzz(
                        author: snapshot.data['buzz'][snapshot.data['buzz']
                                    ['all'][index]['from']]
                                [snapshot.data['buzz']['all'][index]['title']]['author'],
                        category: snapshot.data['buzz'][snapshot.data['buzz']
                                    ['all'][index]['from']]
                                [snapshot.data['buzz']['all'][index]['title']]['category'],
                        msg: snapshot.data['buzz'][snapshot.data['buzz']
                                    ['all'][index]['from']]
                                [snapshot.data['buzz']['all'][index]['title']]['message'],
                        title: snapshot.data['buzz'][snapshot.data['buzz']
                                    ['all'][index]['from']]
                                [snapshot.data['buzz']['all'][index]['title']]['title'],
                        postTime: snapshot.data['buzz'][snapshot.data['buzz']
                                    ['all'][index]['from']]
                                [snapshot.data['buzz']['all'][index]['title']]['postTime'],
                        date: snapshot.data['buzz'][snapshot.data['buzz']
                                    ['all'][index]['from']]
                                [snapshot.data['buzz']['all'][index]['title']]['postDay'],
                        proposedTime: snapshot.data['buzz'][snapshot.data['buzz']
                                    ['all'][index]['from']]
                                [snapshot.data['buzz']['all'][index]['title']]['proposedTime'],
                        venue: snapshot.data['buzz'][snapshot.data['buzz']
                                    ['all'][index]['from']]
                                [snapshot.data['buzz']['all'][index]['title']]['venue']),
                    all: true,
                    channelID: widget.channelID,
                    index: index,
                  );
                },
              );
            }
        }
      },
    );
  }
}
