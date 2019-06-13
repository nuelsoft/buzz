import 'package:flutter/material.dart';
import 'package:buzz/core/buzz.dart';
import 'package:buzz/ui/buzzListsUI/buzzItemUI.dart';

class EventBuzz extends StatelessWidget {
  final List<Buzz> events;
  EventBuzz({this.events});
  @override
  Widget build(BuildContext context) {
    return (events != null && events.length == 0)
        ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              BuzzItem(
                buzz: events[index],
                category: events[index].category,
                showCatAvatar: true,
              );
            },
          )
        : Center(
            child: Text('Nothing here!'),
          );
  }
}
