import 'package:flutter/material.dart';
// import 'package:buzz/core/channel.dart';
import 'package:buzz/core/buzzUser.dart';
import 'package:buzz/ui/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:buzz/ui/auth/master.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cache_image/cache_image.dart';
import 'package:buzz/core/appManager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:buzz/ui/emptySpace.dart';
import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'ads.dart';
// import 'package:buzz/ui/errorHandler.dart';

class ChannelDashboard extends StatefulWidget {
  final String channelID;
  final bool isAdmin;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  ChannelDashboard({this.channelID, this.isAdmin});
  @override
  State<StatefulWidget> createState() {
    return ChannelDashboardState(channelID: channelID);
  }
}

class ChannelDashboardState extends State<ChannelDashboard> {
  final String channelID;
  ChannelDashboardState({this.channelID});
  // bool _switchVal = false;
  bool hasInternet = false;

  StorageReference storage;
  var file;

  bool isProfileChanging = false;

  Future<void> selectPicture(String src) async {
    storage =
        FirebaseStorage.instance.ref().child('channelProfilePics/$channelID');

    file = await ImagePicker.pickImage(
      source: (src == 'camera') ? ImageSource.camera : ImageSource.gallery,
    );
    getInternetStatus();
    if (!hasInternet) {
      widget.scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('You need internet connection to continue')));
      Navigator.pop(context);
      return;
    }
    recoverLostData();
    Navigator.pop(context);
    isProfileChanging = true;

    StorageUploadTask uploadImage = storage.putFile(
        file, StorageMetadata(contentType: 'Image/Profile Picture'));
    StorageTaskSnapshot downloadUrl = await uploadImage.onComplete;
    print(uploadImage.onComplete);
    String actualUrl = await downloadUrl.ref.getDownloadURL();
    fstore
        .collection('channels')
        .document(channelID)
        .setData({'channelPicture': actualUrl}, merge: true);

    setState(() {
      isProfileChanging = false;
      AppManager.dp = actualUrl;
      print('finished the processed:: first');
    });
  }

  Future<void> recoverLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return null;
    }
    if (response.file != null) {
      file = response.file;
    }
  }

  Future<void> getInternetStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternet = true;
      }
    } on SocketException catch (_) {
      hasInternet = false;
    }
  }

  Firestore fstore = Firestore.instance;
  // _switchOnChange(bool value) {
  //   setState(() {
  //     _switchVal = value;
  //   });
  // }

  @override
  void initState() {
    Ads.myBanner
      ..load()
      ..show(anchorType: AnchorType.bottom);

    Ads.myInterstitial
      ..load()
      ..show(anchorType: AnchorType.top);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ErrorWidget.builder = (FlutterErrorDetails error) {
    //   ErrorUI().getErrorUI(context, error);
    // };
    getInternetStatus();
    return Scaffold(
      key: widget.scaffoldKey,
      body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Color.fromRGBO(235, 235, 255, 1),
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return BottomSheet(
                                enableDrag: true,
                                onClosing: () {},
                                builder: (context) => Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Container(
                                        height: 210,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(18),
                                              topLeft: Radius.circular(18),
                                            )),
                                        child: ListView(
                                            physics: BouncingScrollPhysics(),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(16),
                                                child: Text(
                                                  'Select Image Source',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.camera),
                                                title: Text('Camera'),
                                                onTap: () {
                                                  selectPicture('camera');
                                                },
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  selectPicture('gallery');
                                                },
                                                leading: Icon(Icons.photo),
                                                title: Text('Gallery'),
                                              )
                                            ]))));
                          });
                    },
                    icon: Icon(Icons.camera_alt),
                  ),
                  // IconButton(onPressed: () {}, icon: Icon(Icons.delete))
                ],
                expandedHeight: 180,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: StreamBuilder(
                      stream: fstore
                          .collection('channels')
                          .document(channelID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        while (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData) {
                          return Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Container(
                                  child: Text(
                                    snapshot.data['channelName'],
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  width: 220));
                        }
                      }),
                  background: StreamBuilder(
                    stream: fstore
                        .collection('channels')
                        .document(channelID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      while (
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        return (snapshot.data['channelPicture'] != null)
                            ? Stack(fit: StackFit.expand, children: [
                                Center(
                                    child: (hasInternet)
                                        ? Container(
                                            height: 15,
                                            width: 15,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ))
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  height: 15,
                                                  width: 15,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  )),
                                              Text('Waiting for Internet')
                                            ],
                                          )),
                                Center(
                                    child: Image.network(
                                  snapshot.data['channelPicture'],
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                  height: 200,
                                ))
                              ])
                            : Center(
                                child: Icon(
                                  Icons.people,
                                  size: 170,
                                ),
                              );
                      }
                    },
                  ),
                ),
              )
            ];
          },
          body: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Card(
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
                        StreamBuilder(
                          stream: fstore
                              .collection('channels')
                              .document(channelID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            while (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Loading...');
                            }
                            if (snapshot.hasData) {
                              return StreamBuilder(
                                stream: fstore
                                    .collection('userData')
                                    .document(snapshot.data['creator'])
                                    .snapshots(),
                                builder: (context, secondSnapshot) {
                                  while (secondSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('...');
                                  }
                                  if (secondSnapshot.hasData) {
                                    print(secondSnapshot.data['name']);
                                    print(AppManager.myUserID);
                                    return Text(
                                      (snapshot.data['creator'] ==
                                              AppManager.myUserID)
                                          ? 'you'
                                          : secondSnapshot.data['name'],
                                      overflow: TextOverflow.fade,
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ]),
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Channel ID: $channelID'),
                      onTap: () {},
                    ),
                    // ListTile(
                    //   onTap: () {},
                    //   title: Column(
                    //     children: <Widget>[
                    //       Align(
                    //         alignment: Alignment.topLeft,
                    //         child:
                    //             Text('Description', style: TextStyle(fontSize: 12)),
                    //       ),
                    //       Align(
                    //           alignment: Alignment.topLeft,
                    //           child: Text(
                    //               'Buzz Channel for all loosers and suckers and fools')),
                    //     ],
                    //   ),
                    // ),
                    // SwitchListTile(
                    //   value: _switchVal,
                    //   title: Text('Mute Birthday Notifications'),
                    //   onChanged: _switchOnChange,
                    // ),
                    // ListTile(
                    //   enabled: _switchVal,
                    //   title: Text('Mute Notifications Except'),
                    // ),
                    // Divider(),
                    // Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Padding(
                    //       padding: EdgeInsets.only(left: 16),
                    //       child: Text(
                    //         'Members',
                    //         style: TextStyle(
                    //             fontSize: 19, fontWeight: FontWeight.w400),
                    //       ),
                    //     )),
                    StreamBuilder(
                        stream: fstore
                            .collection('channels')
                            .document(channelID)
                            .snapshots(),
                        builder: (context, snap) {
                          while (
                              snap.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snap.hasData && widget.isAdmin) {
                            return ListTile(
                              title: Text('Join Requests'),
                              trailing: Text(
                                  snap.data['joinRequests'].length.toString()),
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      if (snap.data['joinRequests'].length ==
                                          0) {
                                        return Center(
                                          child: Text('No Requests'),
                                        );
                                      }
                                      return ListView.builder(
                                        padding: EdgeInsets.only(bottom: 50),
                                        itemCount:
                                            snap.data['joinRequests'].length,
                                        itemBuilder: (context, index) {
                                          return StreamBuilder(
                                            stream: fstore
                                                .collection('userData')
                                                .document(
                                                    snap.data['joinRequests']
                                                        [index])
                                                .snapshots(),
                                            builder: (context, snp) {
                                              // print(snp.toString());
                                              return Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Column(children: [
                                                    Row(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment
                                                      //         .spaceBetween,
                                                      children: <Widget>[
                                                        Container(
                                                            height: 50,
                                                            width: 50,
                                                            child: ClipOval(
                                                                child: (snp.data[
                                                                            'profileUrl'] !=
                                                                        null)
                                                                    ? Image
                                                                        .network(
                                                                        snp.data[
                                                                            'profileUrl'],
                                                                        // height: 30,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      )
                                                                    : Container(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                      ))),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                  width: 210,
                                                                  child: Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Text(
                                                                        snp.data[
                                                                            'name'],
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                17),
                                                                      ))),
                                                              Container(
                                                                  width: 150,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      snp.data[
                                                                          'bio'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                    ),
                                                                  )),
                                                              // Divider(height: 7,)
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[]))
                                                      ],
                                                    ),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          RaisedButton(
                                                              child: Text(
                                                                'Accept',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              onPressed: () {
                                                                fstore
                                                                    .collection(
                                                                        'channels')
                                                                    .document(
                                                                        channelID)
                                                                    .setData({
                                                                  'users': {
                                                                    snap.data[
                                                                            'joinRequests']
                                                                        [
                                                                        index]: {
                                                                      'joined':
                                                                          '${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}',
                                                                      'isAdmin':
                                                                          false
                                                                    }
                                                                  }
                                                                }, merge: true);
                                                                fstore
                                                                    .collection(
                                                                        'channels')
                                                                    .document(
                                                                        channelID)
                                                                    .setData({
                                                                  'usersOrder':
                                                                      FieldValue
                                                                          .arrayUnion([
                                                                    snap.data[
                                                                            'joinRequests']
                                                                        [index]
                                                                  ])
                                                                }, merge: true);
                                                                fstore
                                                                    .collection(
                                                                        'userData')
                                                                    .document(snap
                                                                            .data['joinRequests']
                                                                        [index])
                                                                    .setData({
                                                                  'channels':
                                                                      FieldValue
                                                                          .arrayUnion([
                                                                    channelID
                                                                  ])
                                                                }, merge: true);

                                                                fstore
                                                                    .collection(
                                                                        'userData')
                                                                    .document(snap
                                                                            .data['joinRequests']
                                                                        [index])
                                                                    .setData({
                                                                  'channels':
                                                                      FieldValue
                                                                          .arrayUnion([
                                                                    channelID
                                                                  ]),
                                                                  'channelLog':
                                                                      {
                                                                    channelID: {
                                                                      'currentNotifications':
                                                                          snap.data[
                                                                              'currentNotifications']
                                                                    }
                                                                  }
                                                                }, merge: true);
                                                                fstore
                                                                    .collection(
                                                                        'channels')
                                                                    .document(
                                                                        channelID)
                                                                    .setData({
                                                                  'joinRequests':
                                                                      FieldValue
                                                                          .arrayRemove([
                                                                    snap.data[
                                                                            'joinRequests']
                                                                        [index]
                                                                  ])
                                                                }, merge: true);
                                                              }),
                                                          RaisedButton(
                                                              child: Text(
                                                                  'Decline'),
                                                              onPressed: () {
                                                                fstore
                                                                    .collection(
                                                                        'channels')
                                                                    .document(
                                                                        channelID)
                                                                    .setData({
                                                                  'joinRequests':
                                                                      FieldValue
                                                                          .arrayRemove([
                                                                    snap.data[
                                                                            'joinRequests']
                                                                        [index]
                                                                  ])
                                                                }, merge: true);
                                                                // Navigator.pop(
                                                                //     context);
                                                              }),
                                                        ])
                                                  ]));
                                            },
                                          );
                                        },
                                      );
                                    });
                              },
                            );
                          } else {
                            return EmptySpace();
                          }
                        }),
                    StreamBuilder(
                      stream: fstore
                          .collection('channels')
                          .document(channelID)
                          .snapshots(),
                      builder: (context, snap) {
                        while (
                            snap.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snap.hasData) {
                          return ListTile(
                            title: Text('Members'),
                            trailing:
                                Text(snap.data['usersOrder'].length.toString()),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                        height: 500,
                                        child: StreamBuilder(
                                            stream: fstore
                                                .collection('channels')
                                                .document(channelID)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              while (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              if (snapshot.hasData) {
                                                return ListView.builder(
                                                    padding: EdgeInsets.only(
                                                        bottom: 50),
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemCount: snapshot
                                                        .data['usersOrder']
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return StreamBuilder(
                                                        stream: fstore
                                                            .collection(
                                                                'userData')
                                                            .document(snapshot
                                                                        .data[
                                                                    'usersOrder']
                                                                [index])
                                                            .snapshots(),
                                                        builder: (context,
                                                            secSnapshot) {
                                                          while (secSnapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Text(
                                                                'Loading...');
                                                          }
                                                          if (secSnapshot
                                                              .hasData) {
                                                            return PersonItem(
                                                              isAdmin: widget
                                                                  .isAdmin,
                                                              buzzUser: BuzzUser(
                                                                  channelId:
                                                                      channelID,
                                                                  userID: snapshot.data['usersOrder']
                                                                      [index],
                                                                  dateJoined: snapshot.data['users']
                                                                          [snapshot.data['usersOrder'][index]][
                                                                      'joined'],
                                                                  bio: secSnapshot.data[
                                                                      'bio'],
                                                                  profileUrl:
                                                                      secSnapshot.data[
                                                                          'profileUrl'],
                                                                  displayName:
                                                                      secSnapshot
                                                                          .data['name'],
                                                                  isAdmin: snapshot.data['users'][snapshot.data['usersOrder'][index]]['isAdmin']),
                                                            );
                                                          }
                                                        },
                                                      );
                                                    });
                                              }
                                            }));
                                  });
                            },
                          );
                        }
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Leave Channel',
                          style: TextStyle(color: Colors.red)),
                      onTap: () {
                        if (!hasInternet) {
                          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  'You need internet connection to complete this action')));
                          // Navigator.pop(context);
                          return;
                        }
                        fstore
                            .collection('userData')
                            .document(AppManager.myUserID)
                            .setData({
                          'channels': FieldValue.arrayRemove([channelID]),
                          'channelLog': {channelID: {}}
                        }, merge: true);
                        fstore
                            .collection('channels')
                            .document(channelID)
                            .setData({
                          'users': {AppManager.myUserID: {}},
                          'usersOrder':
                              FieldValue.arrayRemove([AppManager.myUserID])
                        }, merge: true);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    )
                    // (channel.users != null && channel.users.length > 0)
                    //     ?
                    //     : Center(child: Text('No Members'))
                  ]),
                ),
              ))),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 4, spreadRadius: 1, color: Colors.grey)
          ],
          // border: Border(top: BorderSide(width: 1, color: Colors.black)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white,
        ),
        height: 60,
        child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Row(children: [
              Image(
                height: 30,
                image: AssetImage('assets/img/login_logo.png'),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'Buzz 1.0 Coming Soon...',
                    style: TextStyle(fontSize: 15),
                  ))
            ])),
      ),
      backgroundColor: Color.fromRGBO(235, 235, 255, 1),
    );
  }
}
