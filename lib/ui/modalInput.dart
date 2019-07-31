import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/core/appManager.dart';

class TakeInput extends StatelessWidget {
  final String whichInput;
  TakeInput({this.whichInput});
  static final _profileFormKey = GlobalKey<FormState>();

   static final textFieldController = TextEditingController();
  final Firestore fstore = Firestore.instance;

  void update(String value, BuildContext context) {
    fstore.collection('userData').document(AppManager.myUserID).setData({
      (whichInput == 'bio')
          ? 'bio'
          : (whichInput == 'nick') ? 'nickname' : 'phone': value
    }, merge: true);
    debugPrint(' Value of TextFormField: ' + value);
    textFieldController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        enableDrag: true,
        onClosing: () {},
        builder: (context) => AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: Duration(milliseconds: 500),
              child: Container(
                height: 220,
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
                      padding: EdgeInsets.all(18),
                      child: Text(
                        (whichInput == 'nick')
                            ? 'Nickname'
                            : (whichInput == 'bio') ? 'Bio' : 'Phone',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Form(
                      key: _profileFormKey,
                      autovalidate: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: TextFormField(
                          // initialValue:
                          // '${(whichInput == 'nick') ? (AppManager.nick != null) ? AppManager.nick : '' : (whichInput == 'bio') ? (AppManager.bio != null) ? AppManager.bio : '' : (AppManager.phone != null) ? AppManager.phone : ''}',
                          controller: textFieldController,
                          // autofocus: true,
                          decoration: InputDecoration(
                              labelText:
                                  '${(whichInput == 'nick') ? 'Enter nickname' : (whichInput == 'phone') ? 'Enter Phone number' : 'Enter your bio'}',
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          autocorrect: false,
                          textCapitalization: (whichInput == 'bio')
                              ? TextCapitalization.sentences
                              : TextCapitalization.none,
                          // autovalidate: true,
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Fill out this field';
                            } else {
                              if (whichInput == 'bio') {
                                return (val.length < 3)
                                    ? 'Bio must be at least 3 characters'
                                    : (val.length > 300)
                                        ? 'Bio can\'t excee 350 characters'
                                        : null;
                              } else if (whichInput == 'phone') {
                                RegExp regx = RegExp(r'\+?\d{11,14}');
                                if (!regx.hasMatch(val)) {
                                  return 'Enter valid phone number';
                                } else {
                                  if (val.contains(
                                      RegExp(r'[~`!@#$%^&*()_+;" ]'))) {
                                    return 'Nickname can\'t contain spaces and special characters';
                                  }
                                }
                              }
                            }
                          },
                          keyboardType: (whichInput == 'phone')
                              ? TextInputType.phone
                              : TextInputType.text,
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
                            if (_profileFormKey.currentState.validate()) {
                              update(textFieldController.text, context);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}