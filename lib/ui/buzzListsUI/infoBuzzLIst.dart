import 'package:flutter/material.dart';
import 'buzzItemUI.dart';
import '../../core/buzz.dart';

class InfoBuzz extends StatelessWidget {
  final List<Buzz> infos;
  InfoBuzz({this.infos});
  @override
  Widget build(BuildContext context) {
    return (infos != null && infos.length == 0)
        ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: infos.length,
            itemBuilder: (context, index) {
              BuzzItem(
                buzz: infos[index],
                category: infos[index].category,
                showCatAvatar: true,
              );
            },
          )
        : Center(
            child: Text('Nothing here!'),
          );
  }
}
