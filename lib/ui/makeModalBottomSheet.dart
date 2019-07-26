import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/core/appManager.dart';

class MakeModalBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MakeModalBottomSheetState();
  }
}

class MakeModalBottomSheetState extends State<MakeModalBottomSheet> {
  final channelNameController = TextEditingController();
  final channelIdController = TextEditingController();
  final institutionController = TextEditingController();

  Firestore fstore = Firestore.instance;

  final _formKey = GlobalKey<FormState>();

  void validateAndMake() {
    fstore.collection('channels').document(channelIdController.text).setData({
      'channelName': channelNameController.text,
      'channelId': channelIdController.text,
      'creator': AppManager.myUserID,
      'institution': institutionController.text,
      'groupInfo': 'This is ${channelNameController.text}!',
      'channelMembers': 0,
      'users': [
        {
          'userID': AppManager.myUserID,
          'joined':
              '${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}',
          'isAdmin': true
        }
      ],
      'admins': [
        {
          'userID': AppManager.myUserID,
          'joined':
              '${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}'
        }
      ],
      'polls': [],
      'courses': [],
      'buzzes': [],
      'created':
          '${DateTime.now().day} - ${DateTime.now().month} - ${DateTime.now().year}'
    });
    fstore.collection('userData').document(AppManager.myUserID).updateData({
      'channels': FieldValue.arrayUnion([
        {'channelId': channelIdController.text, 'currentNotification': 0}
      ])
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: true,
      builder: (context) => AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 500),
          child: Container(
            height: 350,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  topLeft: Radius.circular(18),
                )),
            child: ListView(physics: BouncingScrollPhysics(), children: [
              Form(
                key: _formKey,
                // autovalidate: true,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: TextFormField(
                        // autofocus: true,
                        controller: channelNameController,
                        decoration: InputDecoration(
                            labelText: 'Channel Name',
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        // autovalidate: true,
                        validator: (val) {
                          return (val.length == 0)
                              ? 'This can\'t be empty'
                              : (val.contains(RegExp(r'[~`!@#$%^&*()_+<>?]')))
                                  ? 'Can\'t contain special Characters'
                                  : (val.length > 70 || val.length < 5)
                                      ? (val.length > 70)
                                          ? 'Characters in Channel Name can\'t be exceed than 70'
                                          : (val.length < 5)
                                              ? 'Channel Name must be at least 5 characters'
                                              : null
                                      : null;
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: channelIdController,
                        // autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Channel Id',
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.characters,
                        // autovalidate: true,
                        validator: (val) {
                          return (val.length == 0)
                              ? 'Provide a Channel ID'
                              : (val.contains(RegExp(r'[~`!@#$%^&*()-++<>?]')))
                                  ? 'Channel ID can\'t contain special characters'
                                  : (val.length != 6)
                                      ? 'Channel Id must be 6 Characters'
                                      : null;
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: institutionController,
                        // autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Institution',
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        // autovalidate: true,
                        validator: (val) {
                          return (val.length == 0)
                              ? 'Provide your Institution Name'
                              : null;
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).accentColor,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        validateAndMake();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Make Channel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          )),
      onClosing: () {},
    );
  }
}
