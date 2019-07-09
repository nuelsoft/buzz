import 'package:flutter/material.dart';
import 'package:buzz/ui/emptySpace.dart';
import 'package:buzz/core/buzzUser.dart';

class PersonItem extends StatelessWidget {
  final BuzzUser buzzUser;

  PersonItem({this.buzzUser});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: <Widget>[
        CircleAvatar(
          child: (buzzUser.profileUrl.isNotEmpty)
              ? Image.network(buzzUser.profileUrl)
              : Icon(Icons.person),
        ),
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Row(children: [
                Text(buzzUser.displayName),
                (buzzUser.isAdmin)
                    ? Card(
                        elevation: 3,
                        color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 6, bottom: 6, left: 12, right: 12),
                          child: Text(
                            'admin',
                            style: TextStyle(
                                color: Color.fromRGBO(249, 249, 255, 1)),
                          ),
                        ))
                    : EmptySpace()
              ]),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(buzzUser.bio),
            )
          ],
        )
      ],
    ));
  }
}
