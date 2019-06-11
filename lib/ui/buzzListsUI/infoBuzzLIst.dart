import 'package:flutter/material.dart';
import 'buzzItemUI.dart';
import '../../core/constants.dart' show BuzzCategories;
import '../../core/buzz.dart';

class InfoBuzz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        BuzzItem(
          buzz: Buzz(
              author: 'Emmanuel Sunday',
              category: BuzzCategories.event,
              postTime: '2 days ago',
              proposedTime: 'June 11, 2019',
              tag: 'tag',
              title: 'Class meeting',
              venue: 'mango tree',
              msg: 'We will be discussing the tasks of the class reps'),
          category: BuzzCategories.event,
          showCatAvatar: true,
        ),
        BuzzItem(
          buzz: Buzz(
              author: 'Kenneth Bogile',
              category: BuzzCategories.poll,
              postTime: '1 day ago',
              proposedTime: 'June 13, 2019',
              tag: 'tag',
              title: 'Class elections',
              venue: null,
              msg: '...vote in your favorite person '),
          category: BuzzCategories.poll,
          showCatAvatar: true,
        ),
       
        BuzzItem(
          buzz: Buzz(
              author: 'Benjamin Kayode',
              category: BuzzCategories.info,
              postTime: 'now',
              proposedTime: null,
              tag: 'COS 207',
              title: 'COS 207 Practical',
              venue: null,
              msg: 'Make sure to send in your details to me on whatsapp'),
          category: BuzzCategories.info,
          showCatAvatar: true,
        ),
        BuzzItem(
          buzz: Buzz(
              author: 'Kenneth Bogile',
              category: BuzzCategories.poll,
              postTime: '1 day ago',
              proposedTime: 'June 13, 2019',
              tag: 'tag',
              title: 'Class elections',
              venue: null,
              msg: '...vote in your favorite person '),
          category: BuzzCategories.poll,
          showCatAvatar: true,
        ),
        BuzzItem(
          buzz: Buzz(
              author: 'Emmanuel Sunday',
              category: BuzzCategories.event,
              postTime: '2 days ago',
              proposedTime: 'June 11, 2019',
              tag: 'tag',
              title: 'Class meeting',
              venue: 'mango tree',
              msg: 'We will be discussing the tasks of the class reps'),
          category: BuzzCategories.event,
          showCatAvatar: true,
        ),
      ],
    );
  }
}
