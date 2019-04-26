import 'package:flutter/material.dart';
import 'emptySpace.dart';

class NotifyCard extends StatefulWidget {
  @required
  final int unSeen;
  NotifyCard({this.unSeen});

  @override
  State<StatefulWidget> createState() {
    return NotifyCardState(unSeen: unSeen);
  }
}

class NotifyCardState extends State<NotifyCard> {
  int unSeen;
  NotifyCardState({this.unSeen});

  @override
  Widget build(BuildContext context) {
    if (unSeen > 0) {

      String unSeenMsg = unSeen.toString();

      if(unSeen > 99){
        unSeenMsg = '99+';
      }

      return Card(
          elevation: 3,
          color: Theme.of(context).primaryColor,
          child: Padding(
              padding: EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 12),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.notifications_active,
                    color: Theme.of(context).accentColor,
                    size: 17,
                  ),
                  Text(unSeenMsg),
                ],
              )));
    }
    return EmptySpace();
  }
}
