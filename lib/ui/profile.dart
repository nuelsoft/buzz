import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/core/appManager.dart';
import 'package:buzz/ui/modalInput.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
// import 'package:buzz/ui/emptySpace.dart';
// import 'package:cache_image/cache_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'ads.dart';
// import 'package:buzz/ui/errorHandler.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  Firestore fstore = Firestore.instance;
  StorageReference storage = FirebaseStorage.instance
      .ref()
      .child('userProfilePicture/${AppManager.myUserID}');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // Future getPosition() async{
  //   GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
  //   geo
  // }
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

  var file;
  // bool isProfileChanging = false;
  bool hasInternet = false;
  Future<void> selectPicture(String src) async {
    file = await ImagePicker.pickImage(
      source: (src == 'camera') ? ImageSource.camera : ImageSource.gallery,
    );

    getInternetStatus();
    if (!hasInternet) {
      scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('You need internet connection to continue')));
      Navigator.pop(context);
      return;
    }
    recoverLostData();
    Navigator.pop(context);
    // isProfileChanging = true;

    StorageUploadTask uploadImage = storage.putFile(
        file, StorageMetadata(contentType: 'Image/ Profile Picture'));
    StorageTaskSnapshot downloadUrl = await uploadImage.onComplete;
    print(uploadImage.onComplete);

    String actualUrl = await downloadUrl.ref.getDownloadURL();
    fstore
        .collection('userData')
        .document(AppManager.myUserID)
        .setData({'profileUrl': actualUrl}, merge: true);

    setState(() {
      // isProfileChanging = false;
      AppManager.dp = actualUrl;
      print('finished the processed:: first');
    });
  }

  @override
  void initState() {
    Ads.myInterstitial
      ..load()
      ..show(anchorType: AnchorType.top);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    getInternetStatus();
    // ErrorWidget.builder = (FlutterErrorDetails error) {
    //   ErrorUI().getErrorUI(context, error);
    // };
    return Scaffold(
      key: scaffoldKey,
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
                    icon: Icon(
                      Icons.camera_alt,
                      // color: Color.fromRGBO(190, 190, 190, 1)
                    ),
                  )
                ],
                expandedHeight: 170,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Container(
                          child: Text(
                            (AppManager.displayName == null)
                                ? '...'
                                : AppManager.displayName,
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          width: 220)),
                  background: StreamBuilder(
                    stream: fstore
                        .collection('userData')
                        .document(AppManager.myUserID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      while (
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        return (AppManager.dp != null)
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
                                  AppManager.dp,
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                  height: 200,
                                ))
                              ])
                            : Center(
                                child: Icon(
                                  Icons.person,
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
              padding: EdgeInsets.only(bottom: 8),
              child: Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return TakeInput(whichInput: 'nick');
                            });
                      },
                      leading: Icon(Icons.person,
                          color: Color.fromRGBO(
                            100,
                            100,
                            100,
                            1,
                          )),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '~ Nick',
                            style: TextStyle(fontSize: 13),
                          ),
                          StreamBuilder(
                            stream: fstore
                                .collection('userData')
                                .document(AppManager.myUserID)
                                .snapshots(),
                            builder: (builder, snapshot) {
                              if (snapshot.hasData) {
                                AppManager.nick = snapshot.data['nickname'];
                              }
                              return (snapshot.hasData)
                                  ? Text(
                                      (snapshot.data['nickname'] == null ||
                                              snapshot.data['nickname']
                                                  .toString()
                                                  .isEmpty)
                                          ? '@nonick'
                                          : '@${snapshot.data['nickname']}',
                                    )
                                  : Text('...');
                            },
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return TakeInput(whichInput: 'phone');
                            });
                      },
                      leading: Icon(Icons.phone,
                          color: Color.fromRGBO(
                            100,
                            100,
                            100,
                            1,
                          )),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Phone',
                            style: TextStyle(fontSize: 13),
                          ),
                          StreamBuilder(
                            stream: fstore
                                .collection('userData')
                                .document(AppManager.myUserID)
                                .snapshots(),
                            builder: (builder, snapshot) {
                              if (snapshot.hasData) {
                                AppManager.phone = snapshot.data['phone'];
                              }
                              return (snapshot.hasData && snapshot.data != null)
                                  ? Text(
                                      (snapshot.data['phone'] == null ||
                                              snapshot.data['phone']
                                                  .toString()
                                                  .isEmpty)
                                          ? 'click to enter phone'
                                          : snapshot.data['phone'],
                                    )
                                  : Text('...');
                            },
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return TakeInput(whichInput: 'bio');
                            });
                      },
                      leading: Icon(Icons.tag_faces,
                          color: Color.fromRGBO(
                            100,
                            100,
                            100,
                            1,
                          )),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Bio',
                            style: TextStyle(fontSize: 13),
                          ),
                          StreamBuilder(
                            stream: fstore
                                .collection('userData')
                                .document(AppManager.myUserID)
                                .snapshots(),
                            builder: (builder, snapshot) {
                              if (snapshot.hasData) {
                                AppManager.bio = snapshot.data['bio'];
                              }
                              return (snapshot.hasData && snapshot.data != null)
                                  ? Text(
                                      (snapshot.data['bio'] != null &&
                                              snapshot.data['bio']
                                                  .toString()
                                                  .isNotEmpty)
                                          ? snapshot.data['bio']
                                          : 'Click to enter bio',
                                    )
                                  : Text('...');
                            },
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(Icons.email,
                          color: Color.fromRGBO(
                            100,
                            100,
                            100,
                            1,
                          )),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Email',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(AppManager.myEmail)
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(Icons.location_on,
                          color: Color.fromRGBO(
                            100,
                            100,
                            100,
                            1,
                          )),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Location',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            'Coming soon',
                          )
                        ],
                      ),
                    ),
                  ],
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
