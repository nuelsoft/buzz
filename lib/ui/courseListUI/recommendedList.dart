import 'package:flutter/material.dart';
import '../../core/recommendedText.dart';

class RecommendedTextList extends StatelessWidget {
  final List<RecommendedText> texts;
  RecommendedTextList({this.texts});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
        child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 4, left: 2, bottom: 4),
                  child: Text(
                    'Recommended Texts',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                (texts != null && texts.length > 0)
                    ? (Card(
                        child: Expanded(
                        child: ListView.builder(
                            itemCount: texts.length,
                            itemBuilder: (context, index) {
                              Column(children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 6, left: 4, right: 4),
                                  child: Column(children: [
                                    Text(
                                      texts[index].bookTitle,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: Text(
                                        texts[index].author,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Text(
                                        texts[index].url.path,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Text(
                                        texts[index].physicalAddress,
                                      ),
                                    )
                                  ]),
                                ),
                                Divider()
                              ]);
                            }),
                      )))
                    : Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('No Text found'),
                      )
              ],
            )));
  }
}
