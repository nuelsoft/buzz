import 'package:flutter/material.dart';
import 'buzzItemUI.dart';
import '../../core/constants.dart' show BuzzCategories;
import '../../core/buzz.dart';

class InfoBuzz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        BuzzItem(
            buzz: Buzz(
                author: 'Emmanuel Sunday',
                category: BuzzCategories.event,
                postTime: 'now',
                proposedTime: '13-01-19',
                tag: 'tag',
                title: 'Class meeting',
                venue: 'mango tree'))
      ],
    );
  }
}
