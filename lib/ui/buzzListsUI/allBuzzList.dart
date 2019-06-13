import 'package:flutter/material.dart';
import 'package:buzz/core/buzz.dart';
import 'package:buzz/ui/buzzListsUI/buzzItemUI.dart';

class AllBuzz extends StatelessWidget {
 final List<Buzz> buzzes;
  AllBuzz({this.buzzes});
  @override
  Widget build(BuildContext context) {
    return (buzzes != null && buzzes.length > 0)
        ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: buzzes.length,
            itemBuilder: (context, index) {
              BuzzItem(
                buzz: buzzes[index],
                category: buzzes[index].category,
                showCatAvatar: true,
              );
            },
          )
        : 
        Center(
            child: Text('No records!'),
          );
  }
}
