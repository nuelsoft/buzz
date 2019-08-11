import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/core/appManager.dart';
import 'package:buzz/main.dart';

class JoinChannelModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JoinChannelModalState();
  }
}

class JoinChannelModalState extends State<JoinChannelModal> {
  final _formKey = GlobalKey<FormState>();
  final channelIDController = TextEditingController();
  Firestore fstore = Firestore.instance;
  bool isExisting = false;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: true,
      builder: (context) => AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 500),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  topLeft: Radius.circular(18),
                )),
            child: ListView(
                padding: EdgeInsets.only(bottom: 50),
                physics: BouncingScrollPhysics(),
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(top: 16, left: 8, right: 8),
                      child: TextFormField(
                        // autofocus: true,
                        controller: channelIDController,
                        decoration: InputDecoration(
                            labelText: 'Channel Id',
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.characters,
                        autovalidate: true,
                        validator: (val) {
                          fstore
                              .collection('channels')
                              .document(val)
                              .get()
                              .then((snp) {
                            setState(() {
                              isExisting = (snp.exists);
                            });
                          });
                          return (val.length != 6)
                              ? 'Channel Id must be 6 Characters'
                              : (!isExisting) ? 'Channel not found' : null;
                        },
                        keyboardType: TextInputType.text,
                      ),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            var check;

                            fstore
                                .collection('channels')
                                .document(channelIDController.text)
                                .get()
                                .then((val) {
                              check = val;
                              fstore
                                  .collection('userData')
                                  .document(AppManager.myUserID)
                                  .get()
                                  .then((v) {
                                if (v.data['channels']
                                    .contains(channelIDController.text)) {
                                  AppHome().showSnack(
                                      'You are already a member of this channel');
                                  Navigator.pop(context);
                                } else if (check.exists) {
                                  if (!val.data['joinRequests']
                                      .contains(AppManager.myUserID)) {
                                    fstore
                                        .collection('channels')
                                        .document(channelIDController.text)
                                        .setData({
                                      // 'channelName': 'another name',
                                      'joinRequests': FieldValue.arrayUnion(
                                          [AppManager.myUserID])
                                    }, merge: true).whenComplete(() {
                                      // Navigator.pop(context);
                                    });
                                    AppHome().showSnack('Request Sent');
                                  } else {
                                    print('request resent');
                                    AppHome().showSnack(
                                        'Your Request has been resent');
                                    // final snackBar = SnackBar(
                                    //   content: Text('Your Request has been resent!'),
                                    // );
                                    // Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                  Navigator.pop(context);
                                }
                              });
                            });
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Send Join Request',
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
