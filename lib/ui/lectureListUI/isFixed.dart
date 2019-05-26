import 'package:flutter/material.dart';
import '../emptySpace.dart';

class IsFixed extends StatelessWidget {
  bool isFixed;
  IsFixed({this.isFixed});

  @override
  Widget build(BuildContext context) {
    if (isFixed) {
      return Card(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(16)),
        // ),
        color: Color.fromRGBO(0, 0, 255, 1),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Text('fixed',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 17),)),
      );
    } else {
      return EmptySpace();
    }
  }
}
