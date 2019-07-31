import 'package:flutter/material.dart';
// import 'package:buzz/core/SearchDel.dart';
import 'package:buzz/ui/joinModalBottomSheet.dart';
import 'package:buzz/ui/makeModalBottomSheet.dart';

class MakeNJoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MakeNJoinState();
  }
}

class MakeNJoinState extends State<MakeNJoin> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        enableDrag: true,
        builder: (context) => Container(
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Padding(
                padding: EdgeInsets.only(top: 35, bottom: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Row(children: [
                        Icon(Icons.create, color: Color.fromRGBO(0, 0, 255, 1)),
                        Text(
                          'Make Channel',
                          style: TextStyle(color: Color.fromRGBO(0, 0, 255, 1)),
                        )
                      ]),
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Color.fromRGBO(50, 50, 255, 1)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Color.fromRGBO(249, 249, 255, 1),
                      padding: EdgeInsets.all(8),
                      highlightColor: Color.fromRGBO(230, 230, 255, 1),
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => MakeModalBottomSheet());
                      },
                    ),
                    RaisedButton(
                      child: Row(children: [
                        Icon(Icons.people, color: Color.fromRGBO(0, 0, 255, 1)),
                        Text(
                          'Join Channel',
                          style: TextStyle(color: Color.fromRGBO(0, 0, 255, 1)),
                        )
                      ]),
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Color.fromRGBO(50, 50, 255, 1)),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Color.fromRGBO(249, 249, 255, 1),
                      padding: EdgeInsets.all(8),
                      highlightColor: Color.fromRGBO(230, 230, 255, 1),
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => JoinChannelModal());
                      },
                    )
                  ],
                ))));
  }
}
