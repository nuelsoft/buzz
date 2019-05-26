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
        return Icon(Icons.info);
      case 1:
        return Icon(Icons.event);
      case 2:
        return Icon(Icons.poll);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              (showCatAvatar) ? decideAvatar() : EmptySpace(),
              Padding(
                padding: EdgeInsets.only(left: 2),
                child: Text(buzz.title),
              )
            ],
          ),
          Row(children: <Widget>[
            (category == 1)
                ? Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      Text(buzz.venue)
                    ],
                  )
                : EmptySpace(),
            (category != 0)
                ? Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      Text(buzz.proposedTime)
                    ],
                  )
                : EmptySpace()
          ]),
          Row(
            children: <Widget>[
              Text(
                'Published by ',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              Text(
                buzz.author,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text('at', style: TextStyle(fontWeight: FontWeight.w300)),
              Text(
                buzz.postTime,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
