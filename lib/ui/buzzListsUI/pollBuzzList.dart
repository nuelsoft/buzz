import 'package:flutter/material.dart';
import 'package:buzz/ui/buzzListsUI/buzzItemUI.dart';
import 'package:buzz/core/buzz.dart';

class PollBuzz extends StatelessWidget {
  final List<Buzz> polls;
  PollBuzz({this.polls});
  @override
  Widget build(BuildContext context) {
    return (polls != null && polls.length == 0)
        ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: polls.length,
            itemBuilder: (context, index) {
              BuzzItem(
                buzz: polls[index],
                category: polls[index].category,
                showCatAvatar: true,
              );
            },
          )
        : Center(
            child: Text('Nothing here!'),
          );
  }
}
