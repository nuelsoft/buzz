import 'package:flutter/material.dart';

class JoinChannelModal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JoinChannelModalState();
  }
}

class JoinChannelModalState extends State<JoinChannelModal> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: true,
      builder: (context) => AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 500),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  topLeft: Radius.circular(18),
                )),
            child: ListView(physics: BouncingScrollPhysics(), children: [
              Padding(
                padding: EdgeInsets.only(top: 16, left: 8, right: 8),
                child: TextFormField(
                  // autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Channel Id',
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)))),
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
