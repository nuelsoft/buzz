import 'package:flutter/material.dart';

class MakeModalBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MakeModalBottomSheetState();
  }
}

class MakeModalBottomSheetState extends State<MakeModalBottomSheet> {
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
                autovalidate: true,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: TextFormField(
                        // autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Channel Name',
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        autovalidate: true,
                        validator: (val) {
                          return (val.length > 50)
                              ? 'Channel Name must not exceed 50 Characters'
                              : null;
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: TextFormField(
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
                        autovalidate: true,
                        validator: (val) {
                          return (val.length > 6)
                              ? 'Channel Id must be 6 Characters'
                              : null;
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: TextFormField(
                        // autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Location',
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        autovalidate: true,
                        validator: (val) {},
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
                    onPressed: () {},
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
