import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/core/appManager.dart';
import 'package:buzz/ui/modalInput.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  Firestore fstore = Firestore.instance;

  // Future getPosition() async{
  //   GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
  //   geo
  // }
  var file;

  selectPicture(String src) async {
    file = await ImagePicker.pickImage(
      source: (src == 'camera') ? ImageSource.camera : ImageSource.gallery,
    );
    recoverLostData();
    setState(() {});
    Navigator.pop(context);
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
    return Scaffold(
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
                                        height: 170,
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
                    icon: Icon(Icons.camera_alt,
                        color: Color.fromRGBO(190, 190, 190, 1)),
                  )
                ],
                expandedHeight: 190,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      AppManager.displayName,
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(160, 160, 160, 1)),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        (file != null)
                            ? Image.file(
                                file,
                                fit: BoxFit.cover,
                                color: Color.fromRGBO(0, 0, 255, 0.2),
                                colorBlendMode: BlendMode.darken,
                              )
                            : Icon(
                                Icons.person,
                                size: 270,
                                color: Color.fromRGBO(170, 170, 255, 1),
                              ),
                        // Center(
                        //   child: Padding(
                        //       padding: EdgeInsets.only(top: 16),
                        //       child: CircularProgressIndicator()),
                        // )
                      ],
                    )),
              )
            ];
          },
          body: Card(
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
                        'Nsukka, Nigeria',
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
      backgroundColor: Color.fromRGBO(235, 235, 255, 1),
    );
  }
}
