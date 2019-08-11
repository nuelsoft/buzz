import 'package:flutter/material.dart';
// import 'package:buzz/core/SearchDel.dart';
import 'package:buzz/ui/joinModalBottomSheet.dart';
import 'package:buzz/ui/makeModalBottomSheet.dart';
import 'package:buzz/main.dart';
import 'dart:io';

class MakeNJoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MakeNJoinState();
  }
}

class MakeNJoinState extends State<MakeNJoin> {
  bool hasInternet = false;
  Future<void> getInternetStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasInternet = true;
        print('has internet');
      }
    } on SocketException catch (_) {
      hasInternet = false;
      print('no internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    getInternetStatus();
    return BottomSheet(
        onClosing: () {},
        enableDrag: true,
        builder: (context) => Container(
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Padding(
                padding: EdgeInsets.only(top: 0, bottom: 35),
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
                        getInternetStatus();
                        if (!hasInternet) {
                          AppHome().showSnack(
                              'Connect to the internet to Make channel');
                          Navigator.pop(context);
                          return;
                        }
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
                        getInternetStatus();
                        if (!hasInternet) {
                          AppHome().showSnack(
                              'Connect to the internet to Join channel');
                          Navigator.pop(context);
                          return;
                        }
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
