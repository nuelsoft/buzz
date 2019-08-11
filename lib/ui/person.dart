import 'package:flutter/material.dart';
import 'package:buzz/ui/emptySpace.dart';
import 'package:buzz/core/buzzUser.dart';
// import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_admob/firebase_admob.dart';

class PersonItem extends StatelessWidget {
  final bool isAdmin;
  final BuzzUser buzzUser;
  final Firestore fstore = Firestore.instance;
  PersonItem({this.buzzUser, this.isAdmin});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (isAdmin) {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                      height: 110,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          ListTile(
                            title: Text('Let ${buzzUser.displayName} Go'),
                            onTap: () {
                              fstore
                                  .collection('userData')
                                  .document(buzzUser.userID)
                                  .setData({
                                'channels': FieldValue.arrayRemove(
                                    [buzzUser.channelId]),
                                'channelLog': {buzzUser.channelId: {}}
                              }, merge: true);
                              fstore
                                  .collection('channels')
                                  .document(buzzUser.channelId)
                                  .setData({
                                'users': {buzzUser.userID: {}},
                                'usersOrder':
                                    FieldValue.arrayRemove([buzzUser.userID])
                              }, merge: true);
                            },
                          ),
                          (buzzUser.isAdmin)
                              ? ListTile(
                                  title: Text('Remove admin priviledges'),
                                  onTap: () {
                                    fstore
                                        .collection('channels')
                                        .document(buzzUser.channelId)
                                        .setData({
                                      'users': {
                                        buzzUser.userID: {
                                          'isAdmin': false,
                                          'joined': buzzUser.dateJoined,
                                        }
                                      }
                                    }, merge: true);
                                    Navigator.pop(context);
                                    print('stripped ' + buzzUser.userID);
                                  },
                                )
                              : ListTile(
                                  title: Text('Make Admin'),
                                  onTap: () {
                                    fstore
                                        .collection('channels')
                                        .document(buzzUser.channelId)
                                        .setData({
                                      'users': {
                                        buzzUser.userID: {
                                          'isAdmin': true,
                                          'joined': buzzUser.dateJoined,
                                        }
                                      }
                                    }, merge: true);
                                    Navigator.pop(context);
                                  },
                                )
                        ],
                      ));
                });
          }
        },
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: ClipOval(
                      child: (buzzUser.profileUrl != null)
                          ? Image.network(
                              buzzUser.profileUrl,
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            )),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 150,
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              buzzUser.displayName,
                              style: TextStyle(fontSize: 17),
                            ))),
                    Container(
                      width: 150,
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(buzzUser.bio,
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis)),
                    ),
                    // Divider(height: 7,)
                  ],
                ),
                (buzzUser.isAdmin)
                    ? Card(
                        elevation: 3,
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 6, bottom: 6, left: 12, right: 12),
                          child: Text(
                            'admin',
                            style: TextStyle(
                                color: Color.fromRGBO(249, 249, 255, 1)),
                          ),
                        ))
                    : Card(
                        elevation: 1,
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 6, bottom: 6, left: 12, right: 12),
                          child: Text(
                            'member',
                            style: TextStyle(
                                color: Color.fromRGBO(150, 150, 255, 1)),
                          ),
                        ))
              ],
            )));
  }
}
