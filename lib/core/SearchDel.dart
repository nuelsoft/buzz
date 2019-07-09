import 'package:flutter/material.dart';

class SearchDel extends SearchDelegate {
  @override
    ThemeData appBarTheme(BuildContext context) {
      // appBarTheme(context).T
      return super.appBarTheme(context);
    }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(child: Center(child: Text('No result')));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(child: Center(child: Text('No result')));
  }
}
