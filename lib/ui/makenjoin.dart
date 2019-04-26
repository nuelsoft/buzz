import 'package:flutter/material.dart';

class MakeNJoin extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                    padding: EdgeInsets.all(20),
                    onPressed: () {},
                    shape: CircleBorder(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.create),
                        Text('Make Channel')
                      ],
                    )),
                RaisedButton(
                    padding: EdgeInsets.all(23),
                    onPressed: () {},
                    shape: CircleBorder(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.group),
                        Text(
                          'Join Channel',
                        )
                      ],
                    )),
              ],
            ),
          );
  }
}