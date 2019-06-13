import 'package:flutter/material.dart';

import '../../core/buzz.dart';
import '../emptySpace.dart';

class BuzzItem extends StatelessWidget {
  final bool showCatAvatar;
  final Buzz buzz;
  final int category;

  BuzzItem({this.buzz, this.showCatAvatar, this.category});

  Icon decideAvatar() {
    switch (category) {
      case 0:
        return Icon(Icons.info,
            size: 100, color: Color.fromRGBO(20, 20, 255, 0.1));
      case 1:
        return Icon(Icons.event,
            size: 100, color: Color.fromRGBO(20, 20, 255, 0.1));
      case 2:
        return Icon(Icons.poll,
            size: 100, color: Color.fromRGBO(20, 20, 255, 0.1));
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
        Align(
          alignment: Alignment.centerRight,
          child: decideAvatar(),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Text(buzz.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            ),
            Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Text(
                          '"',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                            child: Text(buzz.msg,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                )))
                      ],
                    )),
              ],
            ),
            Row(children: <Widget>[
              (category == 1)
                  ? Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 15,
                            color: Color.fromRGBO(110, 110, 110, 1),
                          ),
                          Text(
                            buzz.venue,
                            // style: TextStyle(
                            //     fontSize: 17, fontWeight: FontWeight.w400),
                          )
                        ],
                      ))
                  : EmptySpace(),
              (category != 0)
                  ? Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            size: 15,
                            color: Color.fromRGBO(110, 110, 110, 1),
                          ),
                          Text(
                            buzz.proposedTime,
                            // style: TextStyle(
                            //     fontSize: 17, fontWeight: FontWeight.w400),
                          )
                        ],
                      ))
                  : EmptySpace()
            ]),
            Padding(
                padding: EdgeInsets.only(top: 4, left: 8, right: 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Published by ',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "@${buzz.author}",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 2, right: 2),
                        child: Text('~',
                            style: TextStyle(fontWeight: FontWeight.w300))),
                    Text(
                      buzz.postTime,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                )),
            Divider(height: 15)
          ]),
        ),
      ]),
    );
  }
}
